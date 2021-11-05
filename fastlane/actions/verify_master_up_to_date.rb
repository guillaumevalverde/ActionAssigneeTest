module Fastlane
  module Actions
    module SharedValues
      IS_MASTER_UP_TO_DATE_RESPONSE = :IS_MASTER_UP_TO_DATE_RESPONSE
    end

    class VerifyMasterUpToDateAction < Action
      def self.run(params)
        release_version_number = params[:release_version_number]
        Actions.sh("git fetch origin main")
        Actions.sh("git fetch origin release/release-#{release_version_number}")
        diff_release_master = Actions.sh("git log --oneline origin/master..origin/release/release-#{release_version_number}")
        is_empty_diff = diff_release_master.empty?
        Actions.lane_context[SharedValues::IS_MASTER_UP_TO_DATE_RESPONSE] = is_empty_diff
        return is_empty_diff
      end

      #####################################################
      # @!group Documentation
      #####################################################

      def self.description
        "Checks if master is up to date with the provided release version number"
      end

      def self.available_options
        [
          FastlaneCore::ConfigItem.new(key: :release_version_number,
                                       env_name: "FL_CHECK_UP_TO_DATE_RELEASE_VERSION_NUMBER",
                                       description: "Release version number. It must contains the version number separated by points, for example '2.7.23'",
                                       verify_block: proc do |value|
                                          UI.user_error!("No release version number given, pass using `release_version_number: 'release version number'`") unless (value and not value.empty?)
                                       end),
        ]
      end

      def self.output
        [
          ['IS_MASTER_UP_TO_DATE_RESPONSE', 'True if master is up to date with the release or false if not']
        ]
      end

      def self.return_value
        "True if master is up to date with the release or false if not"
      end

      def self.is_supported?(platform)
        platform == :android
      end
    end
  end
end
