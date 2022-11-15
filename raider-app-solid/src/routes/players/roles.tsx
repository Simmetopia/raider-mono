import { createResource } from "solid-js";
import { PageTitle } from "~/components/PageTitle";

export default function Roles() {

  const [data] = createResource(async () => {
    const token = sessionStorage.getItem("token")
    const res = await fetch("http://localhost:4000/api/roles", {
      headers: [["authorization", `Bearer ${token}`]]
    })
    return await res.json()
  })

  console.log(data())

  return (
    <>
      <PageTitle>Player roles</PageTitle>
    </>
  );
}
