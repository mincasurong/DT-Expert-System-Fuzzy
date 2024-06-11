# Discrete Time Expert System Using Fuzzy Logic

This repository includes MATLAB code for an expert system based on discrete-time fuzzy logic. The system is designed to make intelligent decisions using fuzzy logic rules.

## Contents

- **[Datasave.txt](Datasave.txt)**: Data file used in the system.
- **[Gauss_mbs.m](Gauss_mbs.m)**: MATLAB function implementing Gaussian membership functions.
- **[Main.m](Main.m)**: Main MATLAB script for running the expert system.
- **[Main_Robot.m](Main_Robot.m)**: MATLAB script for running the expert system in a robotic context.
- **[Main_Robot_While.m](Main_Robot_While.m)**: Another variation of the main script for robotics with a while loop.
- **[fuzzyrule.m](fuzzyrule.m)**: MATLAB script defining the fuzzy logic rules.
- **[tanh_mbs.m](tanh_mbs.m)**: MATLAB function implementing tanh membership functions.

## Getting Started

### Prerequisites

- MATLAB (for running the `.m` files)

### Usage

1. Clone the repository:
    ```bash
    git clone https://github.com/mincasurong/DT-Expert-System-Fuzzy.git
    cd DT-Expert-System-Fuzzy
    ```

2. Open the desired `.m` file in MATLAB and run it to execute the expert system.

### Example

To run the main expert system script:
1. Open `Main.m` in MATLAB.
2. Run the script to see the expert system in action.

For robotic applications:
1. Open `Main_Robot.m` or `Main_Robot_While.m` in MATLAB.
2. Run the script to deploy the expert system in a robotic context.

## Fuzzy Logic Expert System

The expert system uses fuzzy logic to make intelligent decisions based on input data. Fuzzy logic allows the system to handle uncertainty and imprecision, making it suitable for complex decision-making tasks.

### Key Features

- **Fuzzy Logic**: Utilizes fuzzy logic rules for decision making.
- **Membership Functions**: Implements Gaussian and tanh membership functions.
- **Robotic Integration**: Scripts designed for integrating the expert system with robotic applications.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Contributing

Contributions are welcome! Please fork the repository and submit a pull request for any improvements or additions.

## Acknowledgements

Special thanks to the contributors and the MATLAB community for their continuous support and resources.
