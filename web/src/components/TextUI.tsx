import React, { useState, useEffect, useRef, useCallback } from "react";
import { Text, Loader, Title } from "@mantine/core";
import "./TextUI.scss";

interface TextUIData {
  message: string;
  colorProgress?: string;
  keyBind?: string;
  position?: "center-right" | "center-left" | "center";
  useKeybind?: boolean;
  useProgress?: boolean;
  title?: string;
}

const TextUIComponent: React.FC = () => {
  const [textUI, setTextUI] = useState<TextUIData | null>(null);
  const [isVisible, setIsVisible] = useState(false);
  const [animationClass, setAnimationClass] = useState<string>("");
  const timerRef = useRef<NodeJS.Timeout | null>(null);

  const hideTextUI = useCallback(() => {
    setAnimationClass("exiting");
    setTimeout(() => {
      setIsVisible(false);
      setTextUI(null);
      setAnimationClass("");
    }, 500);
  }, []);

  const showTextUI = useCallback(
    (data: TextUIData) => {
      setTextUI(data);
      setIsVisible(true);
      setAnimationClass("entering");
    },
    [hideTextUI]
  );

  useEffect(() => {
    const handleMessage = (event: MessageEvent) => {
      const data = event.data;
      if (data.action === "showTextUI") {
        showTextUI(data);
        console.log(JSON.stringify(data));
      } else if (data.action === "hideTextUI") {
        hideTextUI();
      }
    };

    window.addEventListener("message", handleMessage);
    return () => {
      window.removeEventListener("message", handleMessage);
      if (timerRef.current) {
        clearTimeout(timerRef.current);
      }
    };
  }, [showTextUI, hideTextUI]);

  if (!textUI) {
    return null;
  }

  const getPositionStyle = () => {
    switch (textUI.position) {
      case "center-right":
        return {
          right: "10px",
          top: "50%",
          transform: "translateY(-50%)",
        };
      case "center-left":
        return {
          left: "10px",
          top: "50%",
          transform: "translateY(-50%)",
        };
      case "center":
      default:
        return {
          left: "50%",
          top: "50%",
          transform: "translate(-50%, -50%)",
        };
    }
  };

  const textUIClass = `text-ui ${textUI.position} ${animationClass}`;

  return (
    <div className={textUIClass} style={getPositionStyle()}>
      <div style={{ display: 'flex', flexDirection: 'column', alignItems: 'flex-start', width: '100%' }}>
        {textUI.title && (
          <Title 
            order={5}
            style={{
              marginBottom: '5px',
              textAlign: 'left',
            }}
          >
            {textUI.title}
          </Title>
        )}
        <div className="textui-message">
          {textUI.useKeybind && textUI.keyBind && (
            <div className="textui-bind">
              {textUI.keyBind}
            </div>
          )}
          <div className="textui-message-container">
            {textUI.useProgress ? (
              <Loader
                size="md"
                color={textUI.colorProgress || "rgba(54, 156, 129, 0.381)"}
                style={{ marginRight: "4px" }}
              />
            ) : null}
            <Text
              fz="md"
              style={{ 
                overflowWrap: "break-word", 
                flex: 1, 
                fontFamily: 'Poppins, sans-serif',
                fontWeight: 200, 
              }}
            >
              {textUI.message}
            </Text>
          </div>
        </div>
      </div>
    </div>
  );
};

export default TextUIComponent;
