# Changelog for Komodo

## 0.2.1 (2025-03-29)

- Fix for working with live components. `<.js_component />` inside a LiveComponent will now send events to the LiveComponent rather than the containing LiveView.

## 0.2.0 (2024-10-04)

### Enhancements

- Ability to include static values in callback params (useful for many of the same component on a page, to distinguish with e.g. `id`)
  This change includes changing param spec from `&1.detail.nested` to use of the helper `arg(1, [:detail, :nested])`.

## 0.1.1 (2024-06-07)

First publish, working package with Custom Elements plugin included and third-party plugins for React, Svelte, Vue.
