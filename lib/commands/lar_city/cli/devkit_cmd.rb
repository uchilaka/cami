# frozen_string_literal: true

require_relative 'base_cmd'

module LarCity::CLI
  class DevkitCmd < BaseCmd
    namespace 'devkit'

    option :branch_name,
           type: :string,
           aliases: %w[-b --branch],
           desc: 'The name of the branch to create'
    option :output,
           type: :string,
           aliases: '-o',
           enum: %w[inline web],
           default: 'web',
           required: true
    desc 'branch-review', 'Review the status of the project branches (in source control)'
    def branch_review
      say "Checking branch status for #{selected_branch}...", :yellow
      check_pr_cmd = "gh pr list --head #{selected_branch} --json number -q '.[].number'"
      if dry_run?
        get_pr_number_cmd = <<~CMD
          Executing#{dry_run? ? ' (dry-run)' : ''}: #{check_pr_cmd}
        CMD
        say(get_pr_number_cmd, :magenta)
        return
      end
      output = `#{check_pr_cmd}`.strip
      pr_number = output.to_i

      if pr_number.zero?
        say "No PR found for branch #{selected_branch}.", :red
        # TODO: Refactor PR lookup into a reusable method and loop over
        #   on any branches that fall into this block (pr_number == 0) then
        #   prompt the user on whether they want to delete the branch or not
        return
      end

      say "PR number: #{pr_number}", :green

      case options[:output]
      when 'web'
        run "gh pr view #{pr_number} --web", inline: true
      else
        run "gh pr view #{pr_number}", inline: true
      end
    rescue SystemExit, Interrupt => e
      say "\nTask interrupted.", :red
      exit(1) unless verbose?
      raise e
    rescue StandardError => e
      say "An error occurred: #{e.message}", :red
      exit(1) unless verbose?
      raise e
    end

    desc 'swaggerize', 'Generate Swagger JSON file(s)'
    def swaggerize
      cmd = 'bundle exec rails rswag'
      if verbose?
        puts <<~CMD
          Executing#{dry_run? ? ' (dry-run)' : ''}: #{cmd}
        CMD
      end

      return if dry_run?

      ClimateControl.modify RAILS_ENV: 'test' do
        system(cmd)
      end
    end

    desc 'logs', 'Show the logs for the project'
    def logs
      raise Errors::UnsupportedOSError, 'Unsupported OS' unless mac?

      cmd = "open --url #{log_stream_url}"
      if verbose?
        puts <<~CMD
          Executing#{dry_run? ? ' (dry-run)' : ''}: #{cmd}
        CMD
      end
      system(cmd) unless dry_run?
    end

    no_commands do
      def branch_prompt(context_msg = nil)
        context_msg ||= <<~PROMPT_MSG
          Available branches:
          ===================
          #{branches.map { |i, b| "#{i + 1}. #{is_current_branch_phrase(b)}#{b}" }.join("\n")}
        PROMPT_MSG
        say context_msg
        input = ask('Enter the number of the branch to review:').chomp
        return current_branch_tuple.last if input.blank?

        branch_number = branches.map(&:first).map { |i| (i + 1).to_s }
        raise ArgumentError, 'Invalid branch number' unless branch_number.include?(input)

        # The user input is 1-based, but the array is 0-based
        branches[input.to_i - 1].last
      end

      def branches
        @branches ||=
          if @branches.blank?
            `git branch --list`.split("\n").map.with_index do |b, i|
              [i, b.gsub('*', '').strip]
            end
          end
      end

      def is_current_branch_phrase(branch)
        if branch == current_branch
          '* '
        else
          ''
        end
      end
    end

    private

    def selected_branch
      @selected_branch ||=
        if @selected_branch.blank?
          branch_name = options[:branch_name]
          branch_name ||= branch_prompt
          branch_name
        end
    end

    def current_branch_tuple
      @current_branch_tuple ||= branches.find { |_, b| b == current_branch }
    end

    def current_branch
      @current_branch ||= `git rev-parse --abbrev-ref HEAD`.strip
    end

    def log_stream_url
      team_id, source_id = Rails.application.credentials.betterstack.values_at :team_id, :source_id
      "https://logs.betterstack.com/team/#{team_id}/tail?s=#{source_id}"
    end
  end
end
