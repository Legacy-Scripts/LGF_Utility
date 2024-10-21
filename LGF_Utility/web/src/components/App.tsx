import React, { useState, useEffect } from "react";
import { fetchNui } from "../utils/fetchNui";
import { useNuiEvent } from "../hooks/useNuiEvent";
import { isEnvBrowser } from "../utils/misc";
import ContextMenu from "./ContextMenu";
import NotificationComponent from "./Notification";
import TextUIComponent from "./TextUI";
import DialogComponent from "./Dialog";
import ProgressBar from "./ProgressBar";
import InputComponent from "./Input";
import Instructional from "./Instructional";
import "./ContextMenu.scss";
import "./TextUI.scss";
import "./Dialog.scss";

const App: React.FC = () => {
  const [contextVisible, setContextVisible] = useState(false);
  const [currentMenuID, setCurrentMenuID] = useState<string | null>(null);
  const [buttonVisible, setButtonVisible] = useState(false);
  const [binderControls, setBinderControls] = useState<any>({});
  const [schema, setSchema] = useState<any>({});

  // Handle context menu creation
  useNuiEvent<{ visible: boolean; menuID: string }>(
    "CreateMenuContext",
    ({ visible, menuID }) => {
      setContextVisible(visible);
      setCurrentMenuID(menuID);
    }
  );

  // Handle instructional button display
  useNuiEvent<any>("openInstructionalButt", (data) => {
    setButtonVisible(data.visible);
    setBinderControls(data.controls || {});
    setSchema(data.schema || {});  // Set schema here, providing a default empty object
  });

  // Close context menu handler
  const handleCloseContextMenu = () => {
    if (!isEnvBrowser()) {
      fetchNui("UI:CloseContext", {
        name: "CreateMenuContext",
        menuID: currentMenuID,
      })
      .then(() => {})
      .catch((error) => {
        console.error("Failed to close context menu:", error);
      });
    }
  };

  // Keydown event to handle escape key for closing menus
  useEffect(() => {
    const keyHandler = (e: KeyboardEvent) => {
      if (contextVisible && e.code === "Escape") {
        if (!isEnvBrowser() && contextVisible) {
          handleCloseContextMenu();
        }
      }
    };

    window.addEventListener("keydown", keyHandler);

    return () => {
      window.removeEventListener("keydown", keyHandler);
    };
  }, [contextVisible]);

  return (
    <>
      {contextVisible && currentMenuID && (
        <ContextMenu
          visible={contextVisible}
          menuID={currentMenuID}
          onClose={handleCloseContextMenu}
        />
      )}
      <NotificationComponent />
      <TextUIComponent />
      <DialogComponent />
      <ProgressBar />
      <InputComponent />
      <Instructional 
        visible={buttonVisible} 
        controls={binderControls} 
        schema={schema}  
      />
    </>
  );
};

export default App;
