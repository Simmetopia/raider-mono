import { createRouteAction } from "solid-start";
import { server_response, player } from "~/routes/players";

export const LoginUserForm = () => {
  const [user_login, { Form: FormLogin }] = createRouteAction(
    async (formData: FormData) => {
      const email = formData.get("email");
      const res = await fetch(`http://localhost:4000/api/session/${email}`);

      if (!res.ok) {
        return null;
      }

      const json = (await res.json()) as server_response<player>;
      return json.data;
    }
  );
  return (
    <>
      <h3 class="text-xl"> login </h3>
      {!user_login.error && user_login.result && (
        <div> You looged in {user_login.result.email}</div>
      )}
      <FormLogin class="flex flex-col gap-3 items-start">
        <label for="email">Username:</label>
        <input class="text-black" type="text" name="email" />
        <input type="submit" value="submit" />
      </FormLogin>
    </>
  );
};
