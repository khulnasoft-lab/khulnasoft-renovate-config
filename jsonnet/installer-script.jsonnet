local utils = import 'utils.libsonnet';

{
  customManagers: [
    {
      customType: 'regex',
      fileMatch: ['{{arg0}}'],
      matchStrings: [
        'raw\\.githubusercontent\\.com/khulnasoftproj/khulnasoft-installer/%s/khulnasoft-installer' % utils.currentValue,
      ],
      datasourceTemplate: 'github-releases',
      depNameTemplate: 'khulnasoftproj/khulnasoft-installer',
      versioningTemplate: 'semver',  // https://github.com/renovatebot/renovate/discussions/28150#discussioncomment-8925362
    },
    {
      customType: 'regex',
      fileMatch: ['{{arg0}}'],
      matchStrings: [
        'khulnasoft-installer +(\\| +(ba|z)?sh +-s +-- +)?(-i +\\S+ +)?-v +%s\\s' % utils.currentValue,
        "khulnasoft-installer +(\\| +(ba|z)?sh +-s +-- +)?(-i +\\S+ +)?-v +'%s'\\s" % utils.currentValue,
        'khulnasoft-installer +(\\| +(ba|z)?sh +-s +-- +)?(-i +\\S+ +)?-v +"%s"\\s' % utils.currentValue,
      ],
      datasourceTemplate: 'github-releases',
      depNameTemplate: 'khulnasoft/khulnasoft',
      versioningTemplate: 'semver',  // https://github.com/renovatebot/renovate/discussions/28150#discussioncomment-8925362
    },
  ],
}
