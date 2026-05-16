import { useEffect } from "react";
import { useNuiEvent } from "../hooks/useNuiEvent";
import { applyTheme, convertLuaThemeToShadcn, mergeTheme, darkTheme } from "@/lib/themes";

export interface LuaThemeConfig {
  theme: string;
  [themeName: string]: string | Record<string, string>;
}

export const ThemeInitializer = () => {
  useEffect(() => {
    applyTheme(darkTheme);
  }, []);

  useNuiEvent<LuaThemeConfig>("justgroot:themeplate:theme", (data) => {
    if (!data || !data.theme) {
      return;
    }

    const selectedThemeName = data.theme;
    const themeConfig = data[selectedThemeName];

    if (!themeConfig || typeof themeConfig !== "object") {
      return;
    }

    try {
      const shadcnTheme = convertLuaThemeToShadcn(themeConfig as Record<string, string>);
      const mergedTheme = mergeTheme(shadcnTheme);
      applyTheme(mergedTheme);
    } catch (error) {
      applyTheme(darkTheme);
    }
  });

  return null;
};

export default ThemeInitializer;