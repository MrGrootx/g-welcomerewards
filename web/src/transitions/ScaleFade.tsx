import { AnimatePresence, motion } from "framer-motion";

const ScaleFade: React.FC<{
  visible: boolean;
  children: React.ReactNode;
  onExitComplete?: () => void;
}> = ({ visible, children, onExitComplete }) => {
  return (
    <AnimatePresence onExitComplete={onExitComplete}>
      {visible && (
        <motion.div
          key="scalefade"
          initial={{ opacity: 0, scale: 0.8, y: -20 }}
          animate={{
            opacity: 1,
            scale: 1,
            y: 0,
            transition: { 
              duration: 0.3, 
              ease: [0.25, 0.46, 0.45, 0.94],
              scale: { duration: 0.3 },
              opacity: { duration: 0.2 }
            },
          }}
          exit={{
            opacity: 0,
            scale: 0.8,
            y: -20,
            transition: { 
              duration: 0.2, 
              ease: [0.55, 0.055, 0.675, 0.19] 
            },
          }}
          style={{
            pointerEvents: visible ? "auto" : "none",
            transformOrigin: "center center",
          }}
        >
          {children}
        </motion.div>
      )}
    </AnimatePresence>
  );
};

export default ScaleFade;
