import { createSignal } from "solid-js";
import { createRouteAction } from "solid-start";
import { server_response, player } from "~/routes/players";

export const [token, setToken] = createSignal<string | undefined>();

export const CreateUserForm = () => {
  const [_, { Form }] = createRouteAction(async (formData: FormData) => {
    formData.append("password", "password1234");
    const res = await fetch("http://localhost:4000/api/session", {
      method: "post",
      body: formData,
    });
    const json = (await res.json()) as server_response<player>;
    setToken(json.data.token)
    return json.data;
  });


  return (
    <>
      <h3 class="text-xl"> Create a new player </h3>
      <Form class="flex flex-col gap-3 items-start">
        <label for="email">Username:</label>
        <input class="text-black" type="text" name="email" />
        <input type="submit" value="submit" />
      </Form>
    </>
  );
};
