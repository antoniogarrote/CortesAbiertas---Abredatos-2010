require 'test_helper'

class SessionTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "the object graph must be correctly connected" do
    session = sessions(:session_one)

    assert session.date.instance_of?(Date)
    assert session.interventions.length == 1

    assert session.interventions.first.date.instance_of?(Date)
    assert session.interventions.first.session.id == session.id
    assert session.interventions.first.parliament_member.instance_of?(ParliamentMember)

    assert session.interventions.first.parliament_member.name == "John Locke"
    assert session.interventions.first.parliament_member.interventions.first.id == session.interventions.first.id
  end

  test "data should be correctly transformed into JSON" do
    session = sessions(:session_one).to_json

    decoded = ActiveSupport::JSON.decode(session)
    assert decoded["interventions"].length == 1
  end

end
