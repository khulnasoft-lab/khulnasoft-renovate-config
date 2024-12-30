local utils = import 'utils.libsonnet';

{
  customManagers: [
    utils.khulnasoftRenovateConfigPreset {
      fileMatch: [
        '{{arg0}}',
      ],
    },
  ],
}
