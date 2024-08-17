import React, { useEffect, useState } from "react";
import {
  Text,
  Group,
  ActionIcon,
  ScrollArea,
  Box,
  Stack,
  Transition,
  Button,
  Tooltip,
  useMantineTheme,
  RingProgress,
  Card,
  Badge,
  Flex,
} from "@mantine/core";
import { IoClose } from "react-icons/io5";
import { fetchNui } from "../utils/fetchNui";
import { getIcon } from "../utils/Icon";
import "./ContextMenu.scss";
import { FontAwesomeIcon } from "@fortawesome/react-fontawesome";

interface ContextMenuItem {
  label: string;
  description: string;
  icon: string;
  disabled?: boolean;
  progress?: number;
  colorProgress?: string;
  labelButton?: string;
  metadata?: {
    title?: string;
    iconTitle?: string;
    metadataValue?: Record<string, any>;
  };
  onSelect?: (args: any) => void;
}

interface ContextMenuProps {
  visible: boolean;
  menuID: string;
  onClose: () => void;
}

interface MenuData {
  title: string;
  items: ContextMenuItem[];
}

const ContextMenu: React.FC<ContextMenuProps> = ({
  visible,
  menuID,
  onClose,
}) => {
  const [menuData, setMenuData] = useState<MenuData | null>(null);
  const [isProcessing, setIsProcessing] = useState(false);
  const theme = useMantineTheme();

  useEffect(() => {
    if (visible) {
      const fetchData = async () => {
        try {
          const data = await fetchNui("LGF_UI.GetContextData", { menuID });
          setMenuData(data as MenuData);
        } catch (error) {
          console.error("Failed to fetch menu data:", error);
        }
      };
      fetchData();
    } else {
      setMenuData(null);
    }
  }, [visible, menuID]);

  const handleAction = (index: number) => {
    if (isProcessing) return;

    setIsProcessing(true);
    fetchNui("menu:ItemSelected", { menuID, itemIndex: index })
      .then((response) => {
        console.log("Menu item selected response:", response);
        setIsProcessing(false);
      })
      .catch((error) => {
        console.error("Failed to select menu item:", error);
        setIsProcessing(false);
      });
  };

  return (
    <Transition
      mounted={visible && menuData !== null}
      transition="slide-left"
      duration={500}
      timingFunction="ease"
    >
      {(styles) => (
        <div
          className="menu"
          style={{
            ...styles,
            opacity: styles.opacity,
            right: styles.transform?.includes("translate") ? "20px" : "-500px",
            pointerEvents: styles.opacity === 0 ? "none" : "auto",
            backgroundColor:
              theme.colorScheme === "dark"
                ? theme.colors.dark[9]
                : theme.colors.gray[1],
            borderRadius: "8px",
            padding: "16px",
            boxShadow: theme.shadows.md,
            zIndex: 1000,
          }}
        >
          <Text
            weight={700}
            size="lg"
            align="center"
            ta="center"
            tt="uppercase"
            style={{ marginBottom: "10px" }}
          >
            {menuData?.title}
          </Text>
          <ActionIcon
            color="red"
            className="close-button"
            onClick={onClose}
            title="Close Menu"
            style={{
              position: "absolute",
              top: "10px",
              right: "10px",
            }}
          >
            <IoClose size={20} />
          </ActionIcon>

          <ScrollArea h={800} offsetScrollbars scrollbarSize={7}>
            <Box p="md">
              <Stack spacing="sm">
                {menuData?.items.length === 0 && (
                  <Text color="dimmed" align="center">
                    No options available
                  </Text>
                )}
                {menuData?.items.map((item, index) => (
          
                  <Tooltip
                    key={index}
                    withinPortal
                    zIndex={2000}
                    openDelay={500}
                    disabled={item.metadata ? false: true}
                    label={
                      item.metadata ? (
                        <>
                          <Text
                            weight={500}
                            size="sm"
                            style={{
                              display: "flex",
                              alignItems: "center",
                              marginBottom: "8px",
                              marginRight: "8px",
                            }}
                          >
                            <FontAwesomeIcon
                              icon={
                                item.metadata.iconTitle
                                  ? getIcon(item.metadata.iconTitle)
                                  : getIcon("car")
                              }
                              size="lg"
                              style={{ marginRight: "8px" }}
                            />
                            {item.metadata.title || "Missing Title"}
                          </Text>
                          {item.metadata.metadataValue &&
                            Object.entries(item.metadata.metadataValue).map(
                              ([key, value]) => (
                                <div
                                  key={key}
                                  style={{
                                    display: "flex",
                                    justifyContent: "space-between",
                                    padding: "4px 0",
                                  }}
                                >
                                  <Text tt="uppercase" weight={300} size="xs">
                                    {key
                                      .replace(/([A-Z])/g, " $1")
                                      .toUpperCase()}
                                    :
                                  </Text>

                                  <Badge
                                    variant="light"
                                    color="blue"
                                    size="xs"
                                    radius="xs"
                                    style={{
                                      marginLeft: "10px",
                                    }}
                                  >
                                    {value}
                                  </Badge>
                                </div>
                              )
                            )}
                        </>
                      ) : null
                    }
                    withArrow
                    position="left"
                    color={
                      theme.colorScheme === "dark"
                        ? theme.colors.dark[8]
                        : theme.colors.gray[0]
                    }
                    multiline
                    transitionProps={{
                      transition: "slide-left",
                      duration: 500,
                    }}
                    offset={8}
                    style={{
                      zIndex: 2000,
                      padding: "10px",
                      margin: "8px",
                    }}
                  >
                    <Group
                      className="context-menu-item"
                      style={{
                        display: "flex",
                        justifyContent: "space-between",
                        alignItems: "center",
                        padding: "10px 15px",
                        backgroundColor:
                          theme.colorScheme === "dark"
                            ? theme.colors.dark[7]
                            : theme.colors.gray[0],
                        borderRadius: "4px",
                        cursor: item.disabled ? "not-allowed" : "pointer",
                        transition: "background-color 0.3s",
                      }}
                    >
                      <Group spacing="sm" align="center" style={{ flex: 1 }}>
                        <FontAwesomeIcon icon={getIcon(item.icon)} size="lg" />
                        <Stack spacing={2} style={{ flex: 1 }}>
                          <Text
                            weight={500}
                            style={{
                              color: item.disabled ? "#888" : "#fff",
                            }}
                          >
                            {item.label}
                          </Text>
                          <Text size="sm" color="dimmed">
                            {item.description}
                          </Text>
                        </Stack>
                      </Group>
                      <Flex
                        mih={50}
                        gap="xs"
                        justify="flex-end"
                        align="center"
                        direction="row"
                        wrap="wrap"
                      >
                        {item.progress != null && item.progress > 0 && (
                          <div
                            style={{
                              flexShrink: 0,
                              width: "45px",
                            }}
                          >
                            <RingProgress
                              sections={[
                                {
                                  value: item.progress,
                                  color: item.colorProgress || "blue",
                                },
                              ]}
                              thickness={4}
                              size={40}
                            />
                          </div>
                        )}
                        <Button
                          variant="light"
                          color="blue"
                          onClick={() => !item.disabled && handleAction(index)}
                          disabled={item.disabled}
                          style={{
                            color: item.disabled ? "#555" : "#1e90ff",
                          }}
                        >
                          {item.labelButton || "Action"}
                        </Button>
                      </Flex>
                    </Group>
                  </Tooltip>
                ))}
              </Stack>
            </Box>
          </ScrollArea>
        </div>
      )}
    </Transition>
  );
};

export default ContextMenu;
