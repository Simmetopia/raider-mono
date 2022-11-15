import { createReaction, createResource, For } from "solid-js";
import { createRouteAction, redirect, useRouteData } from "solid-start";
import { PageTitle } from "~/components/PageTitle";
import { CreateUserForm } from "~/components/players/createUserForm";
import { LoginUserForm } from "~/components/players/loginUserForm";

export type player = {
  email: string;
  id: number;
  token?: string;
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

  return (
    <div class="flex flex-col gap-8">
      <PageTitle>Welcome to the site</PageTitle>

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
          <CreateUserForm />
        </section>
        <section>
          <LoginUserForm />
        </section>
      </div>
    </div>
  );
}
