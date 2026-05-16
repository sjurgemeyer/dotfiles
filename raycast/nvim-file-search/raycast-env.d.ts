/// <reference types="@raycast/api">

/* 🚧 🚧 🚧
 * This file is auto-generated from the extension's manifest.
 * Do not modify manually. Instead, update the `package.json` file.
 * 🚧 🚧 🚧 */

/* eslint-disable @typescript-eslint/ban-types */

type ExtensionPreferences = {
  /** Search Root Directory - Root directory to search files in (e.g. ~/projects) */
  "searchRoot": string,
  /** fd Path - Path to the fd binary */
  "fdPath": string,
  /** nvim Path - Path to the nvim binary */
  "nvimPath": string,
  /** Kitty Path - Path to the kitty binary (used when no nvim server is running) */
  "kittyPath": string
}

/** Preferences accessible in all the extension's commands */
declare type Preferences = ExtensionPreferences

declare namespace Preferences {
  /** Preferences accessible in the `index` command */
  export type Index = ExtensionPreferences & {}
}

declare namespace Arguments {
  /** Arguments passed to the `index` command */
  export type Index = {}
}

