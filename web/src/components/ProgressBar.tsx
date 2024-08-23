import React, { useState, useEffect, useRef, useCallback } from "react";
import { Progress, Transition, Text } from "@mantine/core";

interface ProgressData {
  message: string;
  colorProgress?: string;
  position?: "center" | "top" | "bottom";
  duration?: number;
  transition?: string;
}

const ProgressComponents: React.FC = () => {
  const [progressData, setProgressData] = useState<ProgressData | null>(null);
  const [progressValue, setProgressValue] = useState(0); // Inizia da 0
  const [startTime, setStartTime] = useState<number | null>(null);
  const [opened, setOpened] = useState(false);
  const intervalRef = useRef<NodeJS.Timeout | null>(null);


  const showProgressBar = useCallback((data: ProgressData) => {
    setProgressData(data);
    setProgressValue(0);
    setStartTime(Date.now());
    setOpened(true);
  }, []);

  const hideProgressBar = useCallback(() => {
    setOpened(false);
    if (intervalRef.current) {
      clearInterval(intervalRef.current);
    }
  }, []);

  useEffect(() => {
    const handleMessage = (event: MessageEvent) => {
      const data = event.data;
      if (data.action === "showProgressBar") {
        showProgressBar(data);
      } else if (data.action === "hideProgressBar") {
        hideProgressBar();
      }
    };

    window.addEventListener("message", handleMessage);

    return () => {
      window.removeEventListener("message", handleMessage);
    };
  }, [showProgressBar, hideProgressBar]);

  useEffect(() => {
    if (progressData && startTime !== null) {
      const duration = progressData.duration || 5000;
      const updateProgress = () => {
        if (startTime !== null) {
          const elapsedTime = Date.now() - startTime;
          const progress = Math.min(100, (elapsedTime / duration) * 100);
          setProgressValue(progress);

          if (elapsedTime >= duration) {
            hideProgressBar();
          }
        }
      };

      intervalRef.current = setInterval(updateProgress, 100);

      return () => {
        if (intervalRef.current) {
          clearInterval(intervalRef.current);
        }
      };
    }
  }, [progressData, startTime, hideProgressBar]);

  const {
    message = "",
    colorProgress = "rgba(54, 156, 129, 0.9)",
    position = "center",
  } = progressData || {};

  const containerStyles: React.CSSProperties = {
    position: "fixed",
    width: "80%",
    maxWidth: "500px",
    zIndex: 1000,
    padding: "12px",
    color: "#c6c6c6",
    borderRadius: "8px",
    left: "50%",
    transform: "translateX(-50%)",
    ...(position === "top" && { top: "20px", bottom: "auto" }),
    ...(position === "bottom" && { bottom: "20px", top: "auto" }),
    ...(position === "center" && {
      top: "50%",
      left: "50%",
      transform: "translate(-50%, -50%)",
    }),
  };

  const progressContainerStyles: React.CSSProperties = {
    position: "relative",
    height: "22px",
    backgroundColor: "rgba(44, 44, 44, 0.7)",
    borderRadius: "8px",
    width: "100%",
  };

  const percentageStyles: React.CSSProperties = {
    position: "absolute",
    top: "50%",
    left: "50%",
    transform: "translate(-50%, -50%)",
    color: "#ffffff",
    fontSize: "12px",
    fontWeight: "bold",
    pointerEvents: "none",
  };

  return (
    <Transition
      mounted={opened}
      transition="fade"
      duration={400}
      timingFunction="ease"
      onExit={() => {
        setTimeout(() => {
          setProgressData(null);
          setProgressValue(0);
        }, 400);
      }}
    >
      {(styles) => (
        <div style={{ ...containerStyles, ...styles }}>
          <div>
            <Text
              tt="uppercase"
              style={{ marginBottom: "5px", fontSize: "16px" }}
            >
              {message}
            </Text>
            <div style={progressContainerStyles}>
              <Progress
                value={progressValue}
                color={colorProgress}
                radius="sm"
                size="lg"
                striped
                animate
                style={{ height: "100%", borderRadius: "8px" }}
              />
              <div style={percentageStyles}>{Math.round(progressValue)}%</div>
            </div>
          </div>
        </div>
      )}
    </Transition>
  );
};

export default ProgressComponents;
