export const formatTimestamp = (timestamp) => {
    const date = new Date(timestamp * 1000);
    return date.toLocaleString("pl-PL", {
        timeZone: "Europe/Warsaw",
        year: "numeric",
        month: "2-digit",
        day: "2-digit",
        hour: "2-digit",
        minute: "2-digit",
        second: "2-digit"
    });
};

export const isTimestamp = (key, value) =>
    ["exp", "expires_at", "iat", "auth_time"].includes(key) && !isNaN(parseInt(value, 10));
