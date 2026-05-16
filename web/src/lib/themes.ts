export type Theme = Record<string, string>;

const SHADCN_VAR_MAP: Record<string, string> = {
  background: "--background",
  foreground: "--foreground",
  card: "--card",
  card_foreground: "--card-foreground",
  primary: "--primary",
  primary_foreground: "--primary-foreground",
  accent: "--accent",
  border: "--border",
  muted: "--muted",
  muted_foreground: "--muted-foreground",
  secondary: "--secondary",
  secondary_foreground: "--secondary-foreground",
  destructive: "--destructive",
  destructive_foreground: "--destructive-foreground",
  ring: "--ring",
};

function rgbToHsl(rgb: string): string {
  const match = rgb.match(/rgb\s*\(\s*(\d+)\s*,\s*(\d+)\s*,\s*(\d+)\s*\)/i);
  if (!match) {
    return "0 0% 0%";
  }

  const r = parseInt(match[1], 10) / 255;
  const g = parseInt(match[2], 10) / 255;
  const b = parseInt(match[3], 10) / 255;

  const max = Math.max(r, g, b);
  const min = Math.min(r, g, b);
  let h = 0;
  let s = 0;
  const l = (max + min) / 2;

  if (max !== min) {
    const d = max - min;

    if (l > 0.5) {
      s = d / (2 - max - min);
    } else {
      s = d / (max + min);
    }

    if (max === r) {
      h = ((g - b) / d + (g < b ? 6 : 0)) / 6;
    } else if (max === g) {
      h = ((b - r) / d + 2) / 6;
    } else {
      h = ((r - g) / d + 4) / 6;
    }
  }

  const hDeg = Math.round(h * 360);
  const sPercent = Math.max(0, Math.min(100, Math.round(s * 100)));
  const lPercent = Math.max(0, Math.min(100, Math.round(l * 100)));

  return `${hDeg} ${sPercent}% ${lPercent}%`;
}

export function convertLuaThemeToShadcn(
  luaTheme: Record<string, string>
): Theme {
  const shadcnTheme: Theme = {};

  Object.entries(luaTheme).forEach(([key, value]) => {
    const cssVar = SHADCN_VAR_MAP[key];
    if (cssVar && value) {
      shadcnTheme[cssVar] = rgbToHsl(value);
    }
  });

  return shadcnTheme;
}

export const darkTheme: Theme = {
  "--background": "223.8136 0% 3.9388%",
  "--foreground": "223.8136 0.0004% 98.0256%",
  "--card": "223.8136 0% 9.0527%",
  "--card-foreground": "223.8136 0.0004% 98.0256%",
  "--primary": "223.8136 0.0001% 89.8161%",
  "--primary-foreground": "223.8136 0% 9.0527%",
  "--accent": "223.8136 0% 25.0471%",
  "--border": "223.8136 0% 15.5096%",
};

export const blueTheme: Theme = {
  "--primary": "217 91% 60%",
  "--accent": "221 83% 53%",
};

export const themes = {
  dark: darkTheme,
  blue: blueTheme,
};

export function applyTheme(theme: Theme) {
  const root = document.documentElement;
  Object.entries(theme).forEach(([key, value]) => {
    root.style.setProperty(key, value);
  });
}

export function mergeTheme(
  customTheme: Theme,
  defaultTheme: Theme = darkTheme
): Theme {
  return { ...defaultTheme, ...customTheme };
}
