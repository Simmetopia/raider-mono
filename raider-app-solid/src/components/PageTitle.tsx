import { ComponentProps, JSX } from "solid-js";

export const PageTitle = (props: JSX.HTMLAttributes<HTMLHeadingElement>) => {
  return <h1 {...props} class="font-bold text-3xl" />;
};
