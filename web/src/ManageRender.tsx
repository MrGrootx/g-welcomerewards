import Router from "./providers/Router";
import App3 from "./app/App3";
import { VisibilityProvider } from "./providers/VisibilityProvider";
import { debugData } from "./utils/debugData";
import App2 from "./app/App2";

debugData([
  {
    action: "setVisibleApp",
    data: true,
  },
  {
    action: "setVisibleApp2",
    data: false,
  },
  {
    action: "setVisibleApp3",
    data: false,
  },
]);

const ManageRender = () => {
  return (
    <>
      <Router />
      <VisibilityProvider component="App2">
        <App2 />
      </VisibilityProvider>
      <VisibilityProvider component="App3">
        <App3 />
      </VisibilityProvider>
    </>
  );
};

export default ManageRender;
