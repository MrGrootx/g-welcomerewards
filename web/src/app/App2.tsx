import { Button } from "@/components/ui/button";
import { useVisibility } from "../providers/VisibilityProvider";
import React from "react";
import ScaleFade from "@/transitions/ScaleFade";

const App2 = () => {
  const { visible, setVisible } = useVisibility();
  
  if (!visible) return null;
  
  const handleClick = () => {
    console.log("Button clicked!");
    // Your button logic here
  };

  return (
    <ScaleFade 
      visible={visible}
      onExitComplete={() => {
        // Handle exit completion if needed
      }}
    >
      <div className="fixed z-50 w-full h-full">
        <div className="border w-full h-full p-4">
          <div className="p-4 bg-card rounded-lg shadow-lg border border-border/40">
            <Button onClick={handleClick} className="w-full">
              Sec component
            </Button>
          </div>
        </div>
      </div>
    </ScaleFade>
  );
};

export default App2;
