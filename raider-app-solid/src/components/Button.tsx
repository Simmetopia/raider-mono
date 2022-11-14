import { ComponentProps } from "solid-js";
import { A } from "solid-start/router";

type props = {} & ComponentProps<typeof A>;
export const Link = ({ children, ...p }: props) => {
  return (
    <A
      class="bg-teal-600 px-3 py-1 rounded self-start text-stone-900 hover:bg-teal-700"
      {...p}
    >
      {children}
    </A>
  );
};
