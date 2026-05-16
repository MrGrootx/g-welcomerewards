import React from "react";
import { useVisibility } from "@/providers/VisibilityProvider";
import { AnimatePresence, motion } from "framer-motion";
import { useNuiEvent } from "@/hooks/useNuiEvent";
import Welcome from "./Welcome";
 
const App: React.FC = () => {
  const { visible, setVisible } = useVisibility();
  // useEffect(() => {
  //   if (visible && !isAnimating) {
  //     setIsAnimating(true);
  //   }
  // }, [visible, isAnimating]);

  useNuiEvent<boolean>('setVisibleApp', (visible) => {
    setVisible(visible);
  });

  return (
    <div className="fixed inset-0">
      <AnimatePresence>
        {visible && (
          <motion.div
            key="user-ui"
            initial={{ opacity: 0, y: 80 }}
            animate={{
              opacity: 1,
              y: 0,
              transition: {
                duration: 0.35,
                ease: [0.25, 0.46, 0.45, 0.94],
              },
            }}
            exit={{
              opacity: 0,
              y: 80,
              transition: {
                duration: 0.25,
                ease: [0.55, 0.055, 0.675, 0.19],
              },
            }}
            className="fixed inset-0 flex items-center justify-center pointer-events-none"
            onClick={() => setVisible(false)}
          >
            <div className="w-full h-screen flex items-center justify-center p-4 md:p-0">
              <div
                className="bg-card rounded-lg text-muted-foreground flex flex-col overflow-hidden pointer-events-auto "
                style={{ width: "480px" }}
                onClick={(e) => e.stopPropagation()}
              >
                <Welcome />
              </div>
            </div>
          </motion.div>
        )}
      </AnimatePresence>
    </div>
  );
};

export default App;