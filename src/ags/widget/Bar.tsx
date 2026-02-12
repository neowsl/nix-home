import { createBinding, For } from "ags";
import { Astal, Gdk, Gtk } from "ags/gtk4";
import app from "ags/gtk4/app";
import { execAsync } from "ags/process";
import { createPoll } from "ags/time";
import AstalBattery from "gi://AstalBattery";
import AstalHyprland from "gi://AstalHyprland";
import AstalTray from "gi://AstalTray";
import AstalWp from "gi://AstalWp";

const Workspaces = () => {
    const hypr = AstalHyprland.get_default();

    const workspaces = createBinding(
        hypr,
        "workspaces",
    )((w) => w.toSorted((a, b) => a.id - b.id));

    return (
        <box class="workspaces" spacing={2}>
            <For each={workspaces}>
                {(workspace, index) => (
                    <button
                        class={createBinding(
                            hypr,
                            "focusedWorkspace",
                        )((w) => (w.id === workspace.id ? "active" : ""))}
                        onClicked={() => workspace.focus()}
                    >
                        <label label={index((_) => `${workspace.name}`)} />
                    </button>
                )}
            </For>
        </box>
    );
};

const Battery = () => {
    const battery = AstalBattery.get_default();

    const percent = createBinding(
        battery,
        "percentage",
    )((p) => `${Math.floor(p * 100)}`);

    return (
        <box>
            <image iconName={createBinding(battery, "iconName")} />
            <label label={percent} />
        </box>
    );
};

function AudioOutput() {
    const { defaultSpeaker: speaker } = AstalWp.get_default()!;

    const volume = createBinding(
        speaker,
        "volume",
    )((v) => Math.floor(v * 100).toString());

    return (
        <button onClicked={() => execAsync("pavucontrol")}>
            <box>
                <image iconName={createBinding(speaker, "volumeIcon")} />
                <label label={volume} />
            </box>
        </button>
    );
}

const Tray = () => {
    const tray = AstalTray.get_default();

    const items = createBinding(tray, "items");

    const init = (btn: Gtk.MenuButton, item: AstalTray.TrayItem) => {
        btn.menuModel = item.menuModel;
        btn.insert_action_group("dbusmenu", item.actionGroup);
        item.connect("notify::action-group", () => {
            btn.insert_action_group("dbusmenu", item.actionGroup);
        });
    };

    return (
        <box spacing={4}>
            <For each={items}>
                {(item) => (
                    <menubutton $={(self) => init(self, item)}>
                        <image gicon={createBinding(item, "gicon")} />
                    </menubutton>
                )}
            </For>
        </box>
    );
};

const Bar = (gdkmonitor: Gdk.Monitor) => {
    const time = createPoll("", 1000, "date +'%A • %Y-%m-%d • %H:%M:%S'");
    const { TOP, LEFT, RIGHT } = Astal.WindowAnchor;

    return (
        <window
            visible
            name="bar"
            class="Bar"
            gdkmonitor={gdkmonitor}
            exclusivity={Astal.Exclusivity.EXCLUSIVE}
            anchor={TOP | LEFT | RIGHT}
            application={app}
        >
            <centerbox class="container">
                <box class="bubble" $type="start">
                    <Workspaces />
                </box>

                <menubutton class="bubble clock" $type="center">
                    <label label={time} />
                    <popover>
                        <Gtk.Calendar />
                    </popover>
                </menubutton>

                <box $type="end">
                    <box class="bubble" spacing={4}>
                        <Battery />
                        <AudioOutput />
                    </box>
                    <box class="bubble no-gap">
                        <Tray />
                    </box>
                </box>
            </centerbox>
        </window>
    );
};

export default Bar;
