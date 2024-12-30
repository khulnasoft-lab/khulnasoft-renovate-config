local utils = import 'utils.libsonnet';

{
  packageRules: [
    // Some packages are updated by github-tags datasource.
    // So disable github-releases against those packages.
    {
      matchDepNames: utils.githubTagsPackages,
      matchPaths: utils.khulnasoftYAMLMatchPaths,
      matchDatasources: ['github-releases'],
      enabled: false,
    },
    // By default github-tags is disabled.
    {
      matchPaths: utils.khulnasoftYAMLMatchPaths,
      matchDatasources: ['github-tags'],
      enabled: false,
    },
    // github-tags is enabled against only those packages.
    {
      matchDepNames: utils.githubTagsPackages,
      matchPaths: utils.khulnasoftYAMLMatchPaths,
      matchDatasources: ['github-tags'],
      enabled: true,
    },
  ],
  customManagers: [
    {
      // Update khulnasoft-installer action
      customType: 'regex',
      fileMatch: [
        '^action\\.ya?ml$',
        '^\\.github/.*\\.ya?ml$',
        '^\\.circleci/config\\.yml$',
      ],
      matchStrings: [
        ' +%s *: +%s' % [utils.wrapQuote('khulnasoft_version'), utils.currentValue],
        " +%s *: +'%s'" % [utils.wrapQuote('khulnasoft_version'), utils.currentValue],
        ' +%s *: +"%s"' % [utils.wrapQuote('khulnasoft_version'), utils.currentValue],
      ],
      versioningTemplate: 'semver',  // https://github.com/renovatebot/renovate/discussions/28150#discussioncomment-8925362
      depNameTemplate: 'khulnasoft/khulnasoft',
      datasourceTemplate: 'github-releases',
    },
    {
      // Update khulnasoft-installer action
      customType: 'regex',
      fileMatch: [
        '^\\.devcontainer\\.json$',
        '^\\.devcontainer/devcontainer\\.json$',
      ],
      matchStrings: [
        // "khulnasoft_version": "v2.27.0"
        ' +"khulnasoft_version" *: +"%s"' % [utils.currentValue],
      ],
      versioningTemplate: 'semver',  // https://github.com/renovatebot/renovate/discussions/28150#discussioncomment-8925362
      depNameTemplate: 'khulnasoft/khulnasoft',
      datasourceTemplate: 'github-releases',
    },
    utils.khulnasoftRenovateConfigPreset {
      fileMatch: [
        '^renovate\\.json5?$',
        '^\\.github/renovate\\.json5?$',
        '^\\.gitlab/renovate\\.json5?$',
        '^\\.renovaterc\\.json$',
        '^\\.renovaterc$',
      ],
    },
    utils.packageRegexManager {
      datasourceTemplate: 'github-tags',
    },
  ] + utils.customManagers,
}
