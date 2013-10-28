require 'spec_helper'

describe ComposableStateMachine::Transitions do

  let(:transition_map) do
    {
        add: {
            nil => :created
        },
        update: {
            created: :updated,
            updated: :updated,
        },
        remove: {
            created: :removed,
            updated: :removed,
        }
    }
  end

  subject { described_class.new(transition_map) }

  describe '#events' do
    it 'returns all events' do
      subject.events == [:add, :update, :remove]
    end
  end

  describe '#states' do
    it 'returns all states' do
      subject.states =~ [nil, :created, :updated, :removed]
    end
  end

  describe '#on' do
    it 'adds to the transition map' do
      subject.
          on(:remove, nil => :error).
          on(:restore, :removed => :updated)

      subject.events.should eq [:add, :update, :remove, :restore]
      subject.states =~ [nil, :created, :updated, :removed, :error]

      subject.transition(nil, :add).should eq :created
      subject.transition(nil, :remove).should eq :error
      subject.transition(:removed, :restore).should eq :updated
    end

    it 'raises InvalidTransition on transitions to nil' do
      expect do
        subject.on(:expunge, created: nil)
      end.to raise_error ComposableStateMachine::InvalidTransition
    end
  end

  describe '#transition' do
    it 'raises InvalidEvent for unknown events' do
      expect do
        subject.transition(:updated, :unknown)
      end.to raise_error ComposableStateMachine::InvalidEvent
    end

    it 'returns the state to transition to when possible' do
      subject.transition(nil, :add).should eq :created
      subject.transition(:created, :update).should eq :updated
      subject.transition(:updated, :update).should eq :updated
      subject.transition(:created, :remove).should eq :removed
      subject.transition(:updated, :remove).should eq :removed
    end

    it 'returns nil if no transition is possible' do
      subject.transition(nil, :remove).should be_nil
      subject.transition(:created, :add).should be_nil
    end
  end

end
