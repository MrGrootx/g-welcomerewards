import { StrictMode } from "react";
import { createRoot } from "react-dom/client";
import "./index.css";
import { fas } from "@fortawesome/free-solid-svg-icons";
import { far } from "@fortawesome/free-regular-svg-icons";
import { fab } from "@fortawesome/free-brands-svg-icons";
import { library } from "@fortawesome/fontawesome-svg-core";
import { isEnvBrowser } from "./utils/misc";
import ErrorBoundary from "./providers/errorBoundary";
import { ThemeProvider } from "./components/theme-provider";
import { Provider } from "react-redux";
import { store } from "./store/store";
import LocalizationInitializer from "./providers/LocalizationInitializer";
import { QueryClient, QueryClientProvider } from "@tanstack/react-query";
import { HashRouter } from "react-router-dom";
import ManageRender from "./ManageRender";
import ThemeInitializer from "./providers/ThemeInitializer";

library.add(fas, far, fab);

const root = document.getElementById("root");

if (root && isEnvBrowser()) {
  root.style.backgroundImage = 'url("https://i.imgur.com/3pzRj9n.png")';
  root.style.backgroundSize = "cover";
  root.style.backgroundRepeat = "no-repeat";
  root.style.backgroundPosition = "center";
  root.style.minHeight = "100vh";
}

const queryClient = new QueryClient();

createRoot(root!).render(
  <StrictMode>
    <HashRouter>
      <ErrorBoundary>
        <ThemeProvider defaultTheme="dark" storageKey="vite-ui-theme">
          <QueryClientProvider client={queryClient}>
            <Provider store={store}>
              <LocalizationInitializer />
              <ThemeInitializer />
              <ManageRender />
            </Provider>
          </QueryClientProvider>
        </ThemeProvider>
      </ErrorBoundary>
    </HashRouter>
  </StrictMode>
);
