{
  khulnasoftYAMLMatchPaths: [
    '**/.khulnasoft.yaml',
    '**/.khulnasoft.yml',
    '**/khulnasoft.yaml',
    '**/khulnasoft.yml',
  ],
  githubTagsPackages: [
    'golang/go',
    'golang/tools',
    'kubernetes/kubectl',
    'twistedpair/google-cloud-sdk',
    'awslabs/mountpoint-s3',
    'aws/aws-cli',
    'catenacyber/perfsprint',
    'golang/vuln/govulncheck',
  ],
  khulnasoftYAMLFileMatch: ['\\.?khulnasoft\\.ya?ml'],
  wrapQuote(s):: "(?:%s|'%s'|\"%s\")" % [s, s, s],
  currentValue: "(?<currentValue>[^'\" \\n]+)",
  prefixRegexManager(depName, prefix):: {
    customType: 'regex',
    fileMatch: $.khulnasoftYAMLFileMatch,
    matchStrings: $.khulnasoftPackageMatchStrings(depName, prefix),
    extractVersionTemplate: '^%s(?<version>.*)$' % prefix,
    datasourceTemplate: 'github-releases',
    depNameTemplate: depName,
  },
  ipinfo(name):: $.prefixRegexManager('ipinfo/cli/' + name, name + '-') + {
    packageNameTemplate: 'ipinfo/cli',
  },

  khulnasoftPackageMatchStrings(depName, prefix):: [
    ' +%s *: +%s%s +# renovate: depName=%s[ \\n]' % [$.wrapQuote('version'), prefix, $.currentValue, depName],
    " +%s *: +'%s%s' +# renovate: depName=%s[ \\n]" % [$.wrapQuote('version'), prefix, $.currentValue, depName],
    ' +%s *: +"%s%s" +# renovate: depName=%s[ \\n]' % [$.wrapQuote('version'), prefix, $.currentValue, depName],

    ' +%s *: +%s@%s%s' % [$.wrapQuote('name'), depName, prefix, $.currentValue],
    " +%s *: +'%s@%s%s'" % [$.wrapQuote('name'), depName, prefix, $.currentValue],
    ' +%s *: +"%s@%s%s"' % [$.wrapQuote('name'), depName, prefix, $.currentValue],
  ],

  khulnasoftRenovateConfigPreset: {
    // Update khulnasoft-renovate-config
    customType: 'regex',
    matchStrings: [
      '"github>khulnasoft-lab/khulnasoft-renovate-config#(?<currentValue>[^" \\n\\(]+)',
      '"github>khulnasoft-lab/khulnasoft-renovate-config:.*#(?<currentValue>[^" \\n\\(]+)',
      '"github>khulnasoft-lab/khulnasoft-renovate-config/.*#(?<currentValue>[^" \\n\\(]+)',
    ],
    datasourceTemplate: 'github-releases',
    depNameTemplate: 'khulnasoft-lab/khulnasoft-renovate-config',
  },

  // GitHub User and Organization name doesn't include "." and "_".
  depName: "(?<depName>(?<packageName>[^'\" _.@/\\n]+/[^'\" @/\\n]+)(/[^'\" /@\\n]+)*)",
  golangOrgDepName: '(?<depName>golang\\.org/[^\\n]+)',
  goModuleDepName: '(?<depName>_go/(?<packageName>[^#\\n]+)(?:#.*)?)',
  crateDepName: '(?<depName>crates\\.io/(?<packageName>[^\\n]+))',
  gitlabDepName: '(?<depName>gitlab\\.com/(?<packageName>[^\\n]+))',
  giteaDepName: '(?<depName>gitea\\.com/(?<packageName>[^\\n]+))',

  registryRegexManager: {
    customType: 'regex',
    fileMatch: $.khulnasoftYAMLFileMatch,
    matchStrings: [
      ' +%s *: +%s +# renovate: depName=%s' % [$.wrapQuote('ref'), $.currentValue, $.depName],
      " +%s *: +'%s' +# renovate: depName=%s" % [$.wrapQuote('ref'), $.currentValue, $.depName],
      ' +%s *: +"%s" +# renovate: depName=%s' % [$.wrapQuote('ref'), $.currentValue, $.depName],
    ],
    datasourceTemplate: 'github-releases',
  },
  packageRegexManager: {
    customType: 'regex',
    fileMatch: $.khulnasoftYAMLFileMatch,
    matchStrings: [
      ' +%s *: +%s +# renovate: depName=%s' % [$.wrapQuote('version'), $.currentValue, $.depName],
      " +%s *: +'%s' +# renovate: depName=%s" % [$.wrapQuote('version'), $.currentValue, $.depName],
      ' +%s *: +"%s" +# renovate: depName=%s' % [$.wrapQuote('version'), $.currentValue, $.depName],

      ' +%s *: +%s@%s' % [$.wrapQuote('name'), $.depName, $.currentValue],
      " +%s *: +'%s@%s'" % [$.wrapQuote('name'), $.depName, $.currentValue],
      ' +%s *: +"%s@%s"' % [$.wrapQuote('name'), $.depName, $.currentValue],
    ],
    datasourceTemplate: 'github-releases',
  },
  argFileMatch: {
    fileMatch: ['{{arg0}}'],
  },
  fileMatches(fileMatch, managers):: [
    manager {
      fileMatch: fileMatch,
    }
    for manager in managers
  ],
  setCustomTypeRegex(managers):: [
    manager {
      customType: 'regex',
    }
    for manager in managers
  ],

  customManagers: $.setCustomTypeRegex([
    $.packageRegexManager,
    $.registryRegexManager,
    {
      // golang.org
      datasourceTemplate: 'go',
      fileMatch: $.khulnasoftYAMLFileMatch,
      matchStrings: [
        ' +%s *: +%s +# renovate: depName=%s' % [$.wrapQuote('version'), $.currentValue, $.golangOrgDepName],
        " +%s *: +'%s' +# renovate: depName=%s" % [$.wrapQuote('version'), $.currentValue, $.golangOrgDepName],
        ' +%s *: +"%s" +# renovate: depName=%s' % [$.wrapQuote('version'), $.currentValue, $.golangOrgDepName],

        ' +%s *: +%s@%s' % [$.wrapQuote('name'), $.golangOrgDepName, $.currentValue],
        " +%s *: +'%s@%s'" % [$.wrapQuote('name'), $.golangOrgDepName, $.currentValue],
        ' +%s *: +"%s@%s"' % [$.wrapQuote('name'), $.golangOrgDepName, $.currentValue],
      ],
    },
    {
      // Go module
      datasourceTemplate: 'go',
      fileMatch: $.khulnasoftYAMLFileMatch,
      matchStrings: [
        ' +%s *: +%s +# renovate: depName=%s' % [$.wrapQuote('version'), $.currentValue, $.goModuleDepName],
        " +%s *: +'%s' +# renovate: depName=%s" % [$.wrapQuote('version'), $.currentValue, $.goModuleDepName],
        ' +%s *: +"%s" +# renovate: depName=%s' % [$.wrapQuote('version'), $.currentValue, $.goModuleDepName],

        ' +%s *: +%s@%s' % [$.wrapQuote('name'), $.goModuleDepName, $.currentValue],
        " +%s *: +'%s@%s'" % [$.wrapQuote('name'), $.goModuleDepName, $.currentValue],
        ' +%s *: +"%s@%s"' % [$.wrapQuote('name'), $.goModuleDepName, $.currentValue],
      ],
    },
    {
      // Rust crates.io
      datasourceTemplate: 'crate',
      fileMatch: $.khulnasoftYAMLFileMatch,
      matchStrings: [
        ' +%s *: +%s +# renovate: depName=%s' % [$.wrapQuote('version'), $.currentValue, $.crateDepName],
        " +%s *: +'%s' +# renovate: depName=%s" % [$.wrapQuote('version'), $.currentValue, $.crateDepName],
        ' +%s *: +"%s" +# renovate: depName=%s' % [$.wrapQuote('version'), $.currentValue, $.crateDepName],

        ' +%s *: +%s@%s' % [$.wrapQuote('name'), $.crateDepName, $.currentValue],
        " +%s *: +'%s@%s'" % [$.wrapQuote('name'), $.crateDepName, $.currentValue],
        ' +%s *: +"%s@%s"' % [$.wrapQuote('name'), $.crateDepName, $.currentValue],
      ],
      // https://docs.renovatebot.com/modules/versioning/#cargo-versioning
      // The default is 'cargo`, but 'cargo' didnt't update skim 0.10.1 to 0.10.4, so we use 'semver'.
      versioningTemplate: 'semver',
    },
    {
      // Gitlab
      datasourceTemplate: 'gitlab-releases',
      fileMatch: $.khulnasoftYAMLFileMatch,
      matchStrings: [
        ' +%s *: +%s +# renovate: depName=%s' % [$.wrapQuote('version'), $.currentValue, $.gitlabDepName],
        " +%s *: +'%s' +# renovate: depName=%s" % [$.wrapQuote('version'), $.currentValue, $.gitlabDepName],
        ' +%s *: +"%s" +# renovate: depName=%s' % [$.wrapQuote('version'), $.currentValue, $.gitlabDepName],

        ' +%s *: +%s@%s' % [$.wrapQuote('name'), $.gitlabDepName, $.currentValue],
        " +%s *: +'%s@%s'" % [$.wrapQuote('name'), $.gitlabDepName, $.currentValue],
        ' +%s *: +"%s@%s"' % [$.wrapQuote('name'), $.gitlabDepName, $.currentValue],
      ],
    },
    {
      // Gitea
      datasourceTemplate: 'gitea-releases',
      fileMatch: $.khulnasoftYAMLFileMatch,
      matchStrings: [
        ' +%s *: +%s +# renovate: depName=%s' % [$.wrapQuote('version'), $.currentValue, $.giteaDepName],
        " +%s *: +'%s' +# renovate: depName=%s" % [$.wrapQuote('version'), $.currentValue, $.giteaDepName],
        ' +%s *: +"%s" +# renovate: depName=%s' % [$.wrapQuote('version'), $.currentValue, $.giteaDepName],

        ' +%s *: +%s@%s' % [$.wrapQuote('name'), $.giteaDepName, $.currentValue],
        " +%s *: +'%s@%s'" % [$.wrapQuote('name'), $.giteaDepName, $.currentValue],
        ' +%s *: +"%s@%s"' % [$.wrapQuote('name'), $.giteaDepName, $.currentValue],
      ],
    },
    $.prefixRegexManager('oven-sh/bun', 'bun-'),
    $.prefixRegexManager('golang/go', '(go)?') + {
      extractVersionTemplate: '^go(?<version>.*)$',
      datasourceTemplate: 'github-tags',
      versioningTemplate: 'regex:^(?<major>\\d+)\\.(?<minor>\\d+)\\.?(?<patch>\\d+)?$',
    },
    $.prefixRegexManager('golang/tools/gopls', 'gopls/') + {
      packageNameTemplate: 'golang/tools',
    },
    $.prefixRegexManager('ipinfo/cli', 'ipinfo-'),
    $.ipinfo('cidr2ip'),
    $.ipinfo('cidr2range'),
    $.ipinfo('range2cidr'),
    $.ipinfo('prips'),
    $.ipinfo('splitcidr'),
    $.ipinfo('randip'),
    $.ipinfo('grepip'),
    $.ipinfo('range2ip'),
    {
      depNameTemplate: 'kubernetes/kubectl-convert',
      datasourceTemplate: 'github-releases',
      fileMatch: $.khulnasoftYAMLFileMatch,
      matchStrings: $.khulnasoftPackageMatchStrings(self.depNameTemplate, ''),
      packageNameTemplate: 'kubernetes/kubernetes',
    },
    $.prefixRegexManager('kubernetes/kubectl', 'v') + {
      extractVersionTemplate: '^kubernetes-(?<version>.*)$',
      datasourceTemplate: 'github-tags',
    },
    $.prefixRegexManager('kubernetes-sigs/kustomize', 'kustomize/'),
    $.prefixRegexManager('mongodb/mongodb-atlas-cli/atlascli', 'atlascli/') + {
      packageNameTemplate: 'mongodb/mongodb-atlas-cli',
    },
    $.prefixRegexManager('orf/gping', 'gping-'),
    $.prefixRegexManager('jqlang/jq', 'jq-'),
    $.prefixRegexManager('apache/maven', 'maven-'),
    $.prefixRegexManager('grpc/grpc-go/protoc-gen-go-grpc', 'cmd/protoc-gen-go-grpc/') + {
      packageNameTemplate: 'grpc/grpc-go',
    },
    $.prefixRegexManager('awslabs/mountpoint-s3', 'mountpoint-s3-') + {
      datasourceTemplate: 'github-tags',
    },
    {
      packageNameTemplate: '@trunkio/launcher',
      depNameTemplate: 'trunk-io/launcher',
      matchStrings: $.khulnasoftPackageMatchStrings('trunk-io/launcher', ''),
      fileMatch: $.khulnasoftYAMLFileMatch,
      datasourceTemplate: 'npm',
    },
    $.prefixRegexManager('bitwarden/clients', 'cli-'),
  ]),
}
