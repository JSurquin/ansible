import type { NavOperations, ShortcutOptions } from "@slidev/types";
import { defineShortcutsSetup } from "@slidev/types";

export default defineShortcutsSetup(
  (nav: NavOperations, base: ShortcutOptions[]) => {
    return [
      ...base, // keep the existing shortcuts
      {
        key: "enter",
        fn: () => nav.next(),
        autoRepeat: true,
      },
      {
        key: "a",
        fn: () => nav.go("sommaire"),
        autoRepeat: true,
      },
      {
        key: "backspace",
        fn: () => nav.prev(),
        autoRepeat: true,
      },
      {
        key: "n",
        fn: () => nav.toggleDrawing(),
        autoRepeat: true,
      },
      {
        key: "n",
        fn: () => nav.toggleDrawing(),
        autoRepeat: true,
      },
      {
        key: "h",
        fn: () => nav.goFirst(), // Retourne à la première slide
        autoRepeat: false,
      },
      {
        key: "p",
        fn: () => nav.goLast(), // Retourne à la dernière slide
        autoRepeat: false,
      },
      {
        key: "s",
        fn: () => nav.downloadPDF(), // Télécharge le PDF
        autoRepeat: false,
      },
      {
        key: "go",
        fn: () => nav.showGotoDialog(), // Affiche la boite de dialogue de navigation
        autoRepeat: false,
      },
    ];
  },
);
