// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.6.0;
pragma experimental ABIEncoderV2;
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/IERC20.sol";

contract RenewItApps {
   IERC20 token;
   
  address public dev;
  mapping(address => uint) balances;
   
  constructor(IERC20 _token) public {
        balances[dev] = 1000000;
        token = _token;
        dev = msg.sender;
  }
  
    enum RenewItem {
        plasticBottle,
        glassBottle,
        can,
        foodProducts,
        straw,
        styrofoam,
        batteries,
        singleUsePlastic
    }
    
    
    struct User {
        address userAddress;
        string name;
        
    }
    
    struct Driver {
        address drivAddress;
        string name;
        
    }
    
    struct Level {
        uint id;
        string chapter;
        Task task;
    }
    
    struct Task {
        uint id;
        RenewItem rubbish;
        uint accpetanceNumber;
        bytes32 [] uploadImage;
        uint userReward;
        uint driverReward;
        bool completed; // if completed the photo already validate and user rewarded a token
    }
    
    event TaskCreated(uint id, RenewItem rubbish, uint accpetanceNumber, bytes32[]uploadImage, uint userReward, uint driverReward, bool completed);
    event TaskCompleted(uint id, address userAddrs, bool completed);
    
    
    mapping(address => User) public userId;
    mapping(address => Driver) public driverId;
    mapping(uint => Level) public levels;
    mapping(uint => Task) public tasks;
    mapping(address => uint) public userBalance;
    mapping(address => mapping(uint => Task)) public userTask;
    mapping(bytes32 => bool) public photoUploaded;
    mapping(address => bool) public firstTask;
    
   
    bytes32 [] public upload;
    uint public taskId;
    uint public levelId;
    
    
   
    // ====================== ADMIN =========================
     function addTask(RenewItem _rubbish, uint _acceptanceNumber, uint _userToken, uint _driverToken) public {
        tasks[taskId] = Task(taskId, _rubbish, _acceptanceNumber, upload, _userToken, _driverToken,  false);
        emit TaskCreated(taskId, _rubbish, _acceptanceNumber, upload, _userToken, _driverToken, false);
        taskId++;
    }
    
    function insertUserTask(uint id) public{
         // first time user get the task
         require(!firstTask[msg.sender]);
         
         // user get specific task / unique task every user 
         userTask[msg.sender][id] = tasks[id];
         
     }
     
     
    //menambahkan level yang didalamnya sudah ada Task
    // Task ini sudah di deklarasikan dengan fungsi sendiri
    //bagaimana caranya memasukkan task tersebut kedalam Level
     function addLevel(string memory chapter_, Task memory tasks_) public {
        levels[levelId] = Level({id: levelId, chapter: chapter_, task: tasks_});
        levelId++;
    }
    
    // ====================== END USER =========================
     
    function registerUser(string memory userName) public {
        userId[msg.sender] = User(msg.sender, userName);
    }
    
    function registerDriver(string memory driverName) public {
        driverId[msg.sender] = Driver(msg.sender, driverName);
    }
    
    
    function getTask(uint _id) view public returns (uint) {
        return tasks[_id].accpetanceNumber;
    }
    
    function submitPhoto(uint _id, bytes32 image) public imageUploaded(image)  {
         Task storage currentTask = userTask[msg.sender][_id];
         userTask[msg.sender][_id].uploadImage.push(image);
         currentTask.uploadImage.push(image);
        
    }
    
    // user get token automatically after finished the task
    function taskCompleted(uint _id) public validatePhoto taskDidntExists(_id)  returns (bool)  {
        Task storage _tasks = userTask[msg.sender][_id];
        _tasks.completed = true;
        token.transferFrom(address(this), msg.sender, _tasks.userReward);
        emit TaskCompleted(_id, msg.sender, _tasks.completed);
    }
    
    
    
    // ====================== MODIFIER =========================

     // dijadikan modifier
    modifier imageUploaded(bytes32 image) {
        //require that they haven't upload photo before
        require(!photoUploaded[image], "Photo has been uploaded");
        _;
        
    }
    
     modifier validatePhoto() {
         require(!tasks[taskId].completed, "photo already validated by developer");
         _;
    }
    
    // user cant do the same task or specific task has been complete with user
    modifier taskDidntExists(uint id) {
        if(!userTask[msg.sender][id].completed == true) {
            revert("The task didnt exist anymore");
        }
        _;
    }
    
}
