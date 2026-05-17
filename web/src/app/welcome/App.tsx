import React, { useMemo } from "react";
import { useVisibility } from "@/providers/VisibilityProvider";
import { AnimatePresence, motion, type Transition } from "framer-motion";
import { useNuiEvent } from "@/hooks/useNuiEvent";
import Welcome from "./Welcome";
import { useSelector } from "react-redux";
import { RootState } from "@/store/store";
import type { SystemSettings } from "@/types";

type PanelPosition = SystemSettings["position"];

const PANEL_TRANSITION: Transition = {
  duration: 0.35,
  ease: [0.25, 0.46, 0.45, 0.94],
};

const EXIT_TRANSITION: Transition = {
  duration: 0.25,
  ease: [0.55, 0.055, 0.675, 0.19],
};

const POSITION_LAYOUT: Record<
  PanelPosition,
  {
    containerClass: string;
    panelClass: string;
    initial: { opacity: number; x?: number; y?: number };
    animate: { opacity: number; x?: number; y?: number };
    exit: { opacity: number; x?: number; y?: number };
  }
> = {
  left: {
    containerClass: "justify-start items-center",
    panelClass: "ml-4 md:ml-3",
    initial: { opacity: 0, x: -72 },
    animate: { opacity: 1, x: 0 },
    exit: { opacity: 0, x: -56 },
  },
  right: {
    containerClass: "justify-end items-center",
    panelClass: "mr-4 md:mr-3",
    initial: { opacity: 0, x: 72 },
    animate: { opacity: 1, x: 0 },
    exit: { opacity: 0, x: 56 },
  },
  center: {
    containerClass: "justify-center items-center",
    panelClass: "",
    initial: { opacity: 0, y: 72 },
    animate: { opacity: 1, y: 0 },
    exit: { opacity: 0, y: 56 },
  },
};

const App: React.FC = () => {
  const { visible, setVisible } = useVisibility();
  const position = useSelector((state: RootState) => state.welcome.systemSettings.position);

  const layout = useMemo(() => {
    const key: PanelPosition =
      position === "left" || position === "right" || position === "center" ? position : "center";
    return POSITION_LAYOUT[key];
  }, [position]);

  useNuiEvent<boolean>("setVisibleApp", (nextVisible) => {
    setVisible(nextVisible);
  });

  return (
    <motion.div className="fixed inset-0">
      <AnimatePresence>
        {visible && (
          <motion.div
            key={`welcome-ui-${position ?? "center"}`}
            initial={layout.initial}
            animate={{
              ...layout.animate,
              transition: PANEL_TRANSITION,
            }}
            exit={{
              ...layout.exit,
              transition: EXIT_TRANSITION,
            }}
            className={`fixed inset-0 flex pointer-events-none ${layout.containerClass}`}
            onClick={() => setVisible(false)}
          >
            <motion.div
              className={`h-screen flex items-center p-4 md:p-0 pointer-events-auto ${layout.panelClass}`}
              onClick={(e) => e.stopPropagation()}
            >
              <motion.div
                className="bg-card rounded-lg text-muted-foreground flex flex-col overflow-hidden"
                style={{ width: "480px" }}
              >
                <Welcome />
              </motion.div>
            </motion.div>
          </motion.div>
        )}
      </AnimatePresence>
    </motion.div>
  );
};

export default App;
