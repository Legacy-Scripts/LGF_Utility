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
  Progress,
  Badge,
  Flex,
  Divider,
  Title,
  Grid,
  Col,
  Avatar,
  Center,
  ThemeIcon,
} from "@mantine/core";
import { IoClose } from "react-icons/io5";
import { fetchNui } from "../utils/fetchNui";
import { getIcon } from "../utils/Icon";
import styled from "styled-components";
import { FontAwesomeIcon } from "@fortawesome/react-fontawesome";
import { LuFuel } from "react-icons/lu";
import { MapContainer, TileLayer, Marker, Popup, useMap } from "react-leaflet";
import "leaflet/dist/leaflet.css";
import L from "leaflet";
import Map from "./map";

// THX TO https://github.com/BubbleDK/bub-mdt for GameToMap API

const mapCenter: [number, number] = [-119.43, 58.84];
const latPr100 = 1.421;

function gameToMap(x: number, y: number): [number, number] {
  return [
    mapCenter[0] + (latPr100 / 100) * y,
    mapCenter[1] + (latPr100 / 100) * x,
  ];
}

const ScrollBarContainer = styled.div`
  overflow-y: auto;
  overflow-x: hidden;
  flex-grow: 1;
  padding-bottom: 1rem;
  scrollbar-width: none;
  -ms-overflow-style: none;

  &::-webkit-scrollbar {
    display: none;
  }
`;

const MapContainerWrapper = styled.div`
  height: 400px;
  width: 100%;
  position: relative;
  overflow: hidden;
`;

interface ContextMenuItem {
  label: string;
  description: string;
  icon: string;
  disabled?: boolean;
  progress?: number;
  ringProgress?: number;
  colorProgress?: string;
  labelButton?: string;
  image?: string;
  badge?: string;
  actionButton?: boolean;
  metadata?: {
    title?: string;
    iconTitle?: string;
    metadataValue?: Record<string, any>;
  };
  onSelect?: (args: any) => void;
  map?: {
    center: [number, number];
    zoom: number;
    markers: { position: [number, number]; popupText: string; icon: string }[];
    mapLayer?: string;
  };
}

interface ContextMenuProps {
  visible: boolean;
  menuID: string;
}

interface MenuData {
  title: string;
  items: ContextMenuItem[];
}

const CenterMapOnLoad: React.FC<{
  center: [number, number];
  zoom: number;
  bounds: L.LatLngBounds;
}> = ({ center, zoom, bounds }) => {
  const map = useMap();
  console.log(center);
  useEffect(() => {
    if (map) {
      map.setView(center, zoom);
      map.setMaxBounds(bounds);
      map.fitBounds(bounds, { padding: L.point(10, 10) });
    }
  }, [map, center, zoom, bounds]);

  return null;
};

const ContextMenu: React.FC<ContextMenuProps> = ({ visible, menuID }) => {
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

  const bounds = L.latLngBounds(L.latLng(-65, -180), L.latLng(85, 0.0));

  const handleClose = () => {
    fetchNui("UI:CloseContext", { name: "CreateMenuContext", menuID: menuID });
    setTimeout(() => {
      setMenuData(null);
    }, 2000);
  };

  return (
    <Transition
      mounted={visible && menuData !== null}
      transition="slide-right"
      duration={400}
      timingFunction="ease"
    >
      {(styles) => (
        <div
          className="context-menu-container"
          style={{
            position: "fixed",
            top: 0,
            width: "500px",
            height: "100%",
            display: "flex",
            alignItems: "center",
            justifyContent: "center",
            zIndex: 1000,
            ...styles,
          }}
        >
          <Box
            p="sm"
            style={{
              backgroundColor:
                theme.colorScheme === "dark"
                  ? theme.colors.dark[9]
                  : theme.colors.gray[1],
              boxShadow: theme.shadows.sm,
              width: "90%",
              maxWidth: "500px",
              minHeight: "20%",
              maxHeight: "60%",
              overflow: "hidden",
              position: "relative",
              transition: "transform 0.3s ease-in-out",
              margin: "1.5vh",
              display: "flex",
              flexDirection: "column",
            }}
          >
            <Title order={4} align="center" mb="xs">
              {menuData?.title}
            </Title>
            <Divider my="sm" variant="dotted" />
            <ActionIcon
              color="red"
              className="close-button"
              onClick={handleClose}
              title="Close Menu"
              style={{
                position: "absolute",
                top: "10px",
                right: "10px",
              }}
            >
              <IoClose size={20} />
            </ActionIcon>
            <ScrollBarContainer>
              <Stack spacing="sm" p="md">
                {menuData?.items.length === 0 && (
                  <Text color="dimmed" align="center">
                    No options available
                  </Text>
                )}
                {menuData?.items.map((item, index) => (
                  <Grid key={index}>
                    <Col span={12}>
                      <Tooltip
                        withinPortal
                        zIndex={2000}
                        openDelay={500}
                        disabled={!item.metadata}
                        label={
                          item.metadata ? (
                            <div>
                              <Text
                                weight={500}
                                size="sm"
                                style={{
                                  display: "flex",
                                  alignItems: "center",
                                  marginBottom: "8px",
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
                                      <Text
                                        tt="uppercase"
                                        weight={300}
                                        size="xs"
                                      >
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
                            </div>
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
                          transition: "slide-right",
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
                          <Group
                            spacing="sm"
                            align="center"
                            style={{ flex: 1 }}
                          >
                            {item.icon ? (
                              <FontAwesomeIcon
                                icon={getIcon(item.icon)}
                                size="lg"
                              />
                            ) : (
                              <Avatar src={item.image} color="red" size="lg" />
                            )}

                            <Stack spacing={2} style={{ flex: 1 }}>
                              <Group spacing={4} align="center">
                                <Text
                                  weight={500}
                                  style={{
                                    color: item.disabled ? "#888" : "#fff",
                                  }}
                                >
                                  {item.label}
                                </Text>
                              </Group>
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
                            {item.ringProgress != null ? (
                              <div
                                style={{
                                  flexShrink: 0,
                                  width: "45px",
                                }}
                              >
                                <RingProgress
                                  label={
                                    <Center>
                                      <ThemeIcon
                                        color="teal"
                                        variant="light"
                                        radius="xl"
                                        size="xs"
                                      >
                                        <LuFuel size={14} />
                                      </ThemeIcon>
                                    </Center>
                                  }
                                  sections={[
                                    {
                                      value: item.ringProgress,
                                      color:
                                        item.colorProgress ||
                                        theme.colors.teal[5],
                                    },
                                  ]}
                                  thickness={3}
                                  size={40}
                                />
                              </div>
                            ) : item.progress != null ? (
                              <Group spacing={4} align="center">
                                <Text fz="sm">{item.progress}%</Text>
                                <Progress
                                  value={item.progress}
                                  color={item.colorProgress || "teal"}
                                  size="md"
                                  style={{ flexShrink: 0, width: "55px" }}
                                />
                              </Group>
                            ) : null}
                            {item.actionButton !== false && (
                              <Button
                                variant="light"
                                color="blue"
                                onClick={() =>
                                  !item.disabled && handleAction(index)
                                }
                                disabled={item.disabled}
                                style={{
                                  color: item.disabled ? "#555" : "#1e90ff",
                                }}
                              >
                                {item.labelButton || "Action"}
                              </Button>
                            )}
                          </Flex>
                        </Group>
                      </Tooltip>
                      {item.map && (
                        <MapContainerWrapper>
                          <MapContainer
                            key={"game"}
                            center={[-119.43, 58.84]}
                            maxBoundsViscosity={1.0}
                            preferCanvas
                            zoom={2}
                            zoomControl={false}
                            crs={L.CRS.Simple}
                            style={{
                              width: "100%",
                              height: "100%",
                              borderRadius: theme.radius.md,
                              zIndex: 1,
                              backgroundColor: "rgb(13 43 79)",
                            }}
                          >
                            <Map />

                            <React.Suspense>
                              {item.map.markers.map((marker, idx) => {
                                if (
                                  marker.position[0] === 0 &&
                                  marker.position[1] === 0
                                ) {
                                  return null;
                                }

                                return (
                                  <Marker
                                    key={idx}
                                    icon={L.icon({
                                      iconUrl:
                                        marker.icon ||
                                        "https://unpkg.com/leaflet@1.7.1/dist/images/marker-icon.png",
                                      iconSize: [60, 60],
                                      iconAnchor: [12, 41],
                                      popupAnchor: [1, -34],
                                      shadowUrl:
                                        "https://unpkg.com/leaflet@1.7.1/dist/images/marker-shadow.png",
                                      shadowSize: [41, 41],
                                    })}
                                    position={gameToMap(
                                      marker.position[0],
                                      marker.position[1]
                                    )}
                                  >
                                    <Popup>{marker.popupText}</Popup>
                                    <div
                                      style={{
                                        minWidth: 150,
                                        display: "flex",
                                        flexDirection: "column",
                                        gap: 7,
                                      }}
                                    >
                                      <div
                                        style={{
                                          display: "flex",
                                          flexDirection: "row",
                                          gap: 5,
                                          alignItems: "center",
                                        }}
                                      ></div>
                                    </div>
                                  </Marker>
                                );
                              })}
                            </React.Suspense>
                          </MapContainer>
                        </MapContainerWrapper>
                      )}
                    </Col>
                  </Grid>
                ))}
              </Stack>
            </ScrollBarContainer>
          </Box>
        </div>
      )}
    </Transition>
  );
};

export default ContextMenu;
