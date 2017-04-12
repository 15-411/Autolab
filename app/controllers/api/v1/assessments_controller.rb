class Api::V1::AssessmentsController < Api::V1::BaseApiController

  include AssessmentHandinCore
  include AssessmentAutogradeCore

  before_action :set_assessment, except: [:index]

  def index
    asmts = @course.assessments.ordered
    allowed = [:name, :display_name, :description, :start_at, :due_at, :end_at, :updated_at, :max_grace_days, :handout, :writeup, :max_submissions, :disable_handins, :category_name, :group_size, :has_scoreboard, :has_autograder]
    if @cud.student?
      asmts = asmts.released
    else
      allowed += [:visible_at, :grading_deadline]
    end

    results = []
    asmts.each do |asmt|
      result = asmt.attributes.symbolize_keys
      result.merge!(:has_scoreboard => asmt.has_scoreboard?)
      result.merge!(:has_autograder => asmt.has_autograder?)
      results << result
    end

    respond_with results, only: allowed
  end

  # endpoint for obtaining details about all problems of an assessment
  def problems
    problems = @assessment.problems

    respond_with problems, only: [:name, :description, :max_score, :optional]
  end

  # endpoint for obtaining the writeup
  def writeup
    if @assessment.writeup_is_url?
      respond_with_hash({:url => @assessment.writeup}) and return
    end

    if @assessment.writeup_is_file?
      filename = @assessment.writeup_path
      send_file(filename,
                disposition: "inline",
                file: File.basename(filename))
      return
    end

    respond_with_hash({:msg => "There is no writeup for this assessment."})
  end

  # endpoint for submitting to assessments
  # Does not support embedded quizzes.
  # Potential Errors:
  #   Submission Rejected:
  #   - Assessment is an embedded quiz
  #   - Handins disabled
  #   - Submitting late without submit-late flag
  #   - Past assessment end time
  #   - Before assessment start time
  #   - Exceeded max submission count
  #   - Exceeded max handin file size
  #   - Submission was blank
  #   - Submission failed file type check
  #   - Cannot submit until all group members confirm their group membership
  #   - A member of your group has reached the submission limit for this assessment
  #   Autograding Failed:
  #   - No autograding properties
  #   - Error submitting job
  #   - Error uploading submission file
  #   - Submission rejected by autograder
  #   - One or more files in the Autograder module don't exist.
  #   - Encountered unexpected exception
  def submit
    if @assessment.embedded_quiz
      raise ApiError.new("Assessment is an embedded quiz", :bad_request)
    end

    if not params.has_key?(:submission)
      raise ApiError.new("Required parameter 'submission' not found", :bad_request)
    end

    # validate Handin
    validity = validateHandin(params[:submission]["file"].size,
                              params[:submission]["file"].content_type,
                              params[:submission]["file"].original_filename)
    case validity
    when :valid
    when :handin_disabled
      raise ApiError.new("Handins for this assessment is disabled", :forbidden)
    when :submission_empty
      raise ApiError.new("Submission was blank", :forbidden)
    when :file_too_large
      msg = "Submission is larger than the max allowed " \
            "size (#{@assessment.max_size} MB) - please remove any " \
            "unnecessary logfiles and binaries."
      raise ApiError.new(msg, :forbidden)
    when :fail_type_check
      raise ApiError.new("Submission failed Filetype Check", :forbidden)
    else
      raise ApiError.new("Unexpected error during handin validation", :forbidden)
    end

    group_validity = validateHandinForGroups()
    case group_validity
    when :valid
    when :awaiting_member_confirmation
      raise ApiError.new("Submission not allowed until all group members confirm their group membership", :forbidden)
    when :group_submission_limit_exceeded
      raise ApiError.new("A member of your group has reached the submission limit for this assessment", :forbidden)
    else
      raise ApiError.new("Unexpected error during handin validation for groups", :forbidden)
    end

    # attempt to save the submission
    begin
      submissions = saveHandin(params[:submission])
    rescue StandardError => e
      # TODO: log error
      raise ApiError.new("Unexpected error during submission handin", :internal_server_error)
    end

    # autograde the submission
    if @assessment.has_autograder?
      begin
        sendJob(@course, @assessment, submissions, @cud)
      rescue AssessmentAutogradeCore::AutogradeError => e
        raise ApiError.new(e.msg, :internal_server_error)
      end
    end

    respond_with_hash({:success => "Submitted file #{submissions[0].filename} for autograding"})
  end

end