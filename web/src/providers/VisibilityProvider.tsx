import React, {
  Context,
  createContext,
  useContext,
  useEffect,
  useState,
} from "react";
import { useNuiEvent } from "../hooks/useNuiEvent";
import { fetchNui } from "../utils/fetchNui";
import { isEnvBrowser } from "../utils/misc";

const VisibilityCtx = createContext<VisibilityProviderValue | null>(null);

interface VisibilityProviderValue {
  setVisible: (visible: boolean) => void;
  visible: boolean;
}

export const VisibilityProvider: React.FC<{
  children: React.ReactNode;
  component: string;
}> = ({ children, component }) => {
  const stateRef = React.useRef(false);
  const [visible, setVisible] = useState(stateRef.current);

  useNuiEvent<boolean>(`setVisible${component}`, (val) => {
    stateRef.current = val;
    setVisible(val);
  });

  useEffect(() => {
    if (!visible) return;

    const keyHandler = (e: KeyboardEvent) => {
      if (["Escape"].includes(e.code)) {
        if (!isEnvBrowser()) {
          fetchNui("hideFrame", {
            action: `setVisible${component}`,
            data: false,
          });
        } else {
          const newVisible = !visible;
          stateRef.current = newVisible;
          setVisible(newVisible);
        }
      }
    };

    window.addEventListener("keydown", keyHandler);
    return () => window.removeEventListener("keydown", keyHandler);
  }, [visible, component]);

  return (
    <VisibilityCtx.Provider value={{ visible, setVisible }}>
      {children}
    </VisibilityCtx.Provider>
  );
};

export const useVisibility = () =>
  useContext<VisibilityProviderValue>(
    VisibilityCtx as Context<VisibilityProviderValue>
  );
