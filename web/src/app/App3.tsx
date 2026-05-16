import React from "react";
import { Button } from "@/components/ui/button";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Badge } from "@/components/ui/badge";
import LibIcon from "@/components/LibIcon";
import { useVisibility } from "@/providers/VisibilityProvider";

const App3 = () => {
  const { visible, setVisible } = useVisibility();

  if (!visible) return null;

  return (
    <div className="fixed inset-0 flex items-center justify-center">
      <Card className="border-border/40 bg-card shadow-xl w-[50%] m-auto">
        <CardHeader>
          <div className="flex items-center justify-between">
            <CardTitle>App3 - No Route Component</CardTitle>
            <Button
              variant="ghost"
              size="icon"
              className="h-8 w-8 rounded-full"
              onClick={() => setVisible(false)}
            >
              <LibIcon icon="xmark" className="h-4 w-4" />
            </Button>
          </div>
          <Badge variant="secondary">
            <LibIcon icon="info-circle" className="mr-1 h-3 w-3" />
            No Route Component
          </Badge>
        </CardHeader>
        <CardContent>
          <p className="text-muted-foreground mb-4">
            This component renders without routing but still has visibility control.
          </p>
          <div className="space-y-4">
            <Button className="w-full">
              <LibIcon icon="check" className="mr-2 h-4 w-4" />
              Action Button
            </Button>
            <Button variant="outline" className="w-full">
              <LibIcon icon="gear" className="mr-2 h-4 w-4" />
              Settings
            </Button>
          </div>
        </CardContent>
      </Card>
    </div>
  );
};

export default App3;
