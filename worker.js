export default {
    async fetch(request, env, ctx) {
        const url = new URL(request.url);

        if (url.pathname.startsWith("/img/")) {
            const target = new URL(request.url);

            target.hostname = env.IMAGE_HOST;
            target.protocol = "https:";

            const outgoing = new Request(target.toString(), {
                method: request.method,
                headers: request.headers,
                body: request.body,
                redirect: "manual",
            });

            outgoing.headers.set("Host", env.IMAGE_HOST);

            return fetch(outgoing);
        }

        return fetch(request);
    },
};
