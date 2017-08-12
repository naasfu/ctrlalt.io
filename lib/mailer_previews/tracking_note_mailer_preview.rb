class TrackingNoteMailerPreview < ActionMailer::Preview
  def new_tracking
    TrackingNoteMailer.new_tracking(TrackingNote.last)
  end
end
