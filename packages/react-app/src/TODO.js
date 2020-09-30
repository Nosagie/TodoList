import React, { useState } from 'react';
import { ethers } from "ethers";
import { Transactor } from "./helpers"
import { Card,Row,Button } from 'antd';
import { useContractLoader, useContractReader, useBalance } from "./hooks"

const contractName = "ToDos";
const utils = require('ethers').utils;
const { Meta } = Card;

export default function TODO(props){
    
    const [visible] = useState(false);
    const tx = Transactor(props.provider,props.gasPrice)
    const localBalance = useBalance(props.address,props.localProvider)
    const writeContracts = props.writeContracts;
    const contractAddress = props.readContracts?props.readContracts[contractName].address:"";
    var tasks = useContractReader(props.readContracts,contractName,"getAllTasks");
    
    async function markCompleted(taskID){
        let complete = await tx( writeContracts[contractName]["markCompleted"](taskID) );
    }

    async function createETHTask()

    function Task(props) {
        const payAmount = props.task.payToken == 'ETH'? 
                            utils.formatEther(props.task.pay_amount): 
                            props.task.pay_amount.toNumber();
        const etherScan = props.task.payToken=='ETH'? false : 
                            "https://etherscan.io/address/"+props.task.token_address;
        const status = String(props.task.completed) == 'true'? '':'not';
        const completedStatus = status == ''? true:false;
        if (etherScan == false)
        {
            return(
            <Card>
                <p>{props.task.description} </p>
                <p>Payment is {payAmount} {props.task.payToken} </p>
                <p>Task {status} completed</p>
                <Button type="primary" disabled={completedStatus} onClick={() => {markCompleted(props.task.ID)}}> Mark Completed</Button>
                <Meta id={props.task.ID} assigner={props.task.assigner} assignee={props.task.assigner}/>
            </Card>);
        }
        else{
            return(
                <Card>
                    <p>{props.task.description} </p>
                    <p>for {payAmount} {props.task.payToken} </p>
                    <p><a href={etherScan} target="_blank">Token Contract</a></p>
                    <p>Task {status} completed</p>
                    <Button type="primary" disabled={completedStatus} onClick={() => {markCompleted(props.task.ID)}}>Mark Completed</Button>
                <Meta id={props.task.ID} assigner={props.task.assigner} assignee={props.task.assigner}/>
            </Card>);
        }
    }
 

    if (tasks){
        console.log(tasks)
        const taskDisps = tasks.map((task_) => 
        <Task
            task={task_}
        />
        );
        return (
            <div>
                <Row>

                </Row>
                <Row>
                    {taskDisps}
                </Row>
            </div>
        );
    }
    else{
        return (
            <p>no task</p>
        );
    }
}