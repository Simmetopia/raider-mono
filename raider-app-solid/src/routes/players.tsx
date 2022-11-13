import { createReaction, createResource, For } from "solid-js";
import { createRouteAction, redirect, useRouteData } from "solid-start";

export type player = {
  email: string;
  id: number;
};

export type server_response<T> = {
  data: T;
};

export function routeData() {
  const [players] = createResource(async () => {
    const res = await fetch("http://localhost:4000/api/session");
    const json = (await res.json()) as server_response<player[]>;
    return json.data;
  });
  return { players };
}

export default function Page() {
  const { players } = useRouteData<typeof routeData>();

  const [_, { Form }] = createRouteAction(async (formData: FormData) => {
    formData.append("password", "password1234");
    const res = await fetch("http://localhost:4000/api/session", {
      method: "post",
      body: formData,
    });
    const json = (await res.json()) as server_response<player>;
    return json.data;
  });

  const [user_login, { Form: FormLogin }] = createRouteAction(
    async (formData: FormData) => {
      const email = formData.get("email");
      const res = await fetch(`http://localhost:4000/api/session/${email}`);
      const json = (await res.json()) as server_response<player>;
      return json.data;
    }
  );
  return (
    <div class="bg-slate-800 text-white min-h-screen px-32 flex flex-col gap-16">
      <h1 class="text-2xl">Welcome to the site</h1>

      <section class="text-xl">
        <h3>Users already signed up</h3>
        <For each={players()}>
          {(player) => {
            return <div> i am player {player.email}</div>;
          }}
        </For>
      </section>
      <div class="flex flex-row gap-3">
        <section>
          <h3 class="text-xl"> Create a new player </h3>
          <Form class="flex flex-col gap-3 items-start">
            <label for="email">Username:</label>
            <input class="text-black" type="text" name="email" />
            <input type="submit" value="submit" />
          </Form>
        </section>
        <section>
          <h3 class="text-xl"> login </h3>
          {!user_login.error && user_login.result && (
            <div> You looged in {user_login.result.email}</div>
          )}
          <FormLogin class="flex flex-col gap-3 items-start">
            <label for="email">Username:</label>
            <input class="text-black" type="text" name="email" />
            <input type="submit" value="submit" />
          </FormLogin>
        </section>
      </div>
    </div>
  );
}
