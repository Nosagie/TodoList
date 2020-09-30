import React from "react";
import { PageHeader,Descriptions } from "antd";

export default function Header() {
  return (
      <PageHeader
        title="Task Manager"
        subTitle="built with 🏗 scaffold-eth"
        style={{ cursor: "pointer" }}
        extra={[
              <a href="https://github.com/austintgriffith/scaffold-eth" target="_blank">
                Check out Scaffold ETH!
                </a>
        ]}
      />
  );
}
