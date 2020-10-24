# wow-addon-template
A template repo for how I setup my WoW Addons for development.

## TODOs for this template
- Can you generate Changelogs?
- Can we automate any/all of these steps with a CLI w/ prompts?

## Steps to use this template

1. Update all the values in `AddonName.toc` to be correct, deleting saved variables lines if unnecessary
1. Rename `AddonName.toc` to have your exact AddonName
1. Update environment variables in `.github/workflows/release.yml` so that builds will work
1. Tag the repo as `wow-addon` so it's more discoverable.
1. Update the rest of the readme
1. Delete everything through here and including this in the Readme.

AddonName
=========

A short description of what this addon does, who it's for

Get it on [WoW Interface](WOWILINK) or use the [Cursebreaker tool](https://github.com/AcidWeb/CurseBreaker) (recommended)


## Changelog
- Put patch notes here

## Contributing

### Contributing Fixes/Features
1. Fork the repo
1. Make your changes in the fork
1. Submit a Pull Request back for review to this repo
1. I'll review it when I can and we can talk about it

### Localization

If you'd like to help localize the text here, simply follow the above steps and change the Localization.lua file to add your translations. Please submit an [issue on GitHub](GHISSUESLINK) if you need any assistance with this workflow.