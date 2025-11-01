# Pact homebrew-tap

The Pact Standalone public homebrew tap for MacOS / Linux homebrew formulae.

The easier way to install the Pact CLI tools on your MacOS/Linux machine using Homebrew.

## Installation

    brew tap pact-foundation/tap
    brew install pact

or in a single line

    brew install pact-foundation/tap/pact

##  Supported Platforms

| OS      | Architecture | Supported |
| ------- | ------------ | --------- |
| MacOS   | x86_64       | ✅        |
| MacOS   | arm64        | ✅        |
| Linux   | x86_64       | ✅        |
| Linux   | arm64        | ✅        |

## Included tools

- broker       A Rust and CLI client for the Pact Broker. Publish and retrieve pacts and verification  results.
- pactflow     PactFlow specific commands
- completions  Generates completion scripts for your shell
- extension    Manage Pact CLI extensions
- plugin       CLI utility for Pact plugins
- mock         Standalone Pact mock server
- verifier     Standalone pact verifier for provider pact verification
- stub         Pact Stub Server 0.7.0
- help         Print this message or the help of the given subcommand(s)

      ├── pact (central entry point to all binaries)
      ├── pact broker
      ├── pact pactflow
      ├── pact plugin
      ├── pact mock
      ├── pact stub
      ├── pact verifier
      ├── pact completions
      ├── pact stub
      └── pact extension

### Individual Tools

### Pact Mock Server Cli

    brew install pact-foundation/tap/pact-mock-server

### Pact Stub Server Cli

    brew install pact-foundation/tap/pact-stub-server

### Pact Verifier Cli

    brew install pact-foundation/tap/pact-verifier

### Pact Plugin Cli

    brew install pact-foundation/tap/pact-plugin

### Pact Broker Client

    brew install pact-foundation/tap/pact-broker-client

### Pact Ruby Standalone (Legacy)

The following command can be used to install the pact ruby standalone bundle which is now in maintainence mode.

    brew install pact-foundation/tap/pact-legacy

Older install commands are supported, due to repository rename redirects, and Homebrew Aliases.

    brew install pact-foundation/pact-ruby-standalone/pact-standalone
    brew install pact-foundation/homebrew-pact-ruby-standalone/pact-standalone
    brew install pact-foundation/pact-standalone/pact-standalone
    brew install pact-foundation/homebrew-pact-standalone/pact-standalone

### Included legacy tools

```
├── pact-broker
├── pactflow
├── pact-message
├── pact-mock-service
├── pact-provider-verifier
└── pact-stub-service
```
