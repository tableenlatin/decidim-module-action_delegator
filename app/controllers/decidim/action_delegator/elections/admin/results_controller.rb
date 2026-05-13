# frozen_string_literal: true

module Decidim
  module ActionDelegator
    module Elections
      module Admin
        class ResultsController < ActionDelegator::Admin::ApplicationController
          include ::Decidim::ActionDelegator::SettingsHelper
          before_action :enforce_election_permission

          def by_type_and_weight
            render json: {
              id: election.id,
              ongoing: election.ongoing?,
              questions: election.questions.map do |question|
                {
                  id: question.id,
                  response_options: elections_question_responses_by_type(question)
                }
              end
            }
          end

          def sum_of_weights
            render json: {
              id: election.id,
              ongoing: election.ongoing?,
              questions: election.questions.map do |question|
                {
                  id: question.id,
                  response_options: elections_question_weighted_responses(question)
                }
              end
            }
          end

          def totals
            render json: {
              id: election.id,
              ongoing: election.ongoing?,
              questions: election.questions.map do |question|
                { id: question.id }.merge(
                  elections_question_stats(question)
                )
              end
            }
          end

          private

          def enforce_election_permission
            enforce_permission_to :dashboard, :election, election:
          end

          def election
            @election ||= begin
              record = Decidim::Elections::Election.includes(questions: { votes: :versions }).find(params[:id])
              raise ActiveRecord::RecordNotFound unless record.component.organization == current_organization

              record
            end
          end
        end
      end
    end
  end
end
