# Security Policy

## Supported Versions

Security fixes target the latest published npm version.

## Reporting a Vulnerability

Do not open a public issue for secrets, authentication bypasses, or exploitable installer behavior.

Report vulnerabilities by contacting the repository owner through GitHub or EvoLink support. Include the affected package version, reproduction steps, exposed secret or URL scope, and suggested mitigation if known.

## Handling Secrets

Never commit EvoLink API keys. The examples and installer expect keys through `EVOLINK_API_KEY`.
