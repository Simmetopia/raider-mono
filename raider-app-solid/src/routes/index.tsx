import { A } from "solid-start";
import { Link } from "~/components/Button";
import Counter from "~/components/Counter";
import { PageTitle } from "~/components/PageTitle";

export default function Home() {
  return (
    <main class="flex flex-col gap-3">
      <PageTitle>Welcome to raider app</PageTitle>
      <Link href="/players">Go to players screen</Link>
    </main>
  );
}
