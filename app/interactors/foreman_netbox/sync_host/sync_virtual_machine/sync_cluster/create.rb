# frozen_string_literal: true

module ForemanNetbox
  module SyncHost
    module SyncVirtualMachine
      module SyncCluster
        class Create
          include ::Interactor

          around do |interactor|
            interactor.call unless context.cluster
          end

          def call
            context.cluster = ForemanNetbox::API.client::Virtualization::Cluster.new(params).save
          rescue NetboxClientRuby::LocalError, NetboxClientRuby::ClientError, NetboxClientRuby::RemoteError => e
            Foreman::Logging.exception("#{self.class} error:", e)
            context.fail!(error: "#{self.class}: #{e}")
          end

          private

          def params
            {
              type: context.cluster_type&.id,
              name: context.host.compute_object&.cluster,
              tags: ForemanNetbox::SyncHost::Organizer::DEFAULT_TAGS
            }
          end
        end
      end
    end
  end
end
