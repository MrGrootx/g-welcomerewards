import App from "@/app/welcome/App";
import App2 from "@/app/App2";
import { Route, Routes } from "react-router-dom";
import { VisibilityProvider } from "./VisibilityProvider";

const Router: React.FC = () => {
  return (
    <Routes>
      <Route
        index
        element={
          <VisibilityProvider component="App">
            <App />
          </VisibilityProvider>
        }
      />
    </Routes>
  );
};

export default Router;
