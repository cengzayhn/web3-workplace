<!DOCTYPE html>
<html lang="en">
<head>
<h1>BikeRental Contract</h1>

<h2>Overview</h2>
<p>The <code>BikeRental</code> contract is designed to manage a decentralized bike rental system on the Ethereum blockchain.</p>

<h2>Data Structures</h2>

<h3>Variables</h3>
<ul>
    <li><code>address payable public owner</code>: Stores the owner of the contract who deployed it.</li>
    <li><code>uint256 public constant rentalPrice</code>: The rental price for a bike, set at 2 wei.</li>
    <li><code>uint256 public rentalDuration</code>: Duration for which a bike can be rented, set to 1 day.</li>
</ul>

<h3>Enum</h3>
<ul>
    <li><code>enum Statuses { Available, Rented }</code>: Represents the status of a bike, whether it is available for rent or currently rented.</li>
</ul>

<h3>Struct</h3>
<ul>
    <li><code>struct Bike</code>: Represents a bike with the following properties:
        <ul>
            <li><code>uint256 bikeId</code>: Unique identifier for the bike.</li>
            <li><code>string model</code>: Model of the bike.</li>
            <li><code>Statuses status</code>: Current status of the bike (available or rented).</li>
            <li><code>uint256 rentedUntil</code>: Timestamp until which the bike is rented.</li>
        </ul>
    </li>
</ul>

<h3>Mapping</h3>
<ul>
    <li><code>mapping(uint256 => Bike) public bikes</code>: Maps a bike's ID to its corresponding <code>Bike</code> struct.</li>
</ul>

<h2>Events</h2>
<ul>
    <li><code>event Rent(address indexed renter, uint256 value, uint256 bikeId, uint256 rentedUntil)</code>: Emitted when a bike is rented.</li>
    <li><code>event Return(uint256 bikeId)</code>: Emitted when a bike is returned.</li>
    <li><code>event Refund(uint256 bikeId)</code>: Emitted when a refund is processed.</li>
</ul>

<h2>Constructor</h2>
<p><code>constructor()</code>: Initializes the contract by setting the contract deployer as the owner and adding two bikes (<code>Mountain Bike</code> and <code>Road Bike</code>) to the <code>bikes</code> mapping with IDs 1 and 2.</p>

<h2>Modifiers</h2>
<ul>
    <li><code>modifier onlyAvailable(uint256 bikeId)</code>: Ensures the bike is available before proceeding with a function.</li>
    <li><code>modifier costs(uint256 amount)</code>: Ensures the message value sent with a transaction meets or exceeds a specified amount.</li>
</ul>

<h2>Functions</h2>

<h3>Execute Functions</h3>
<ol>
    <li>
        <p><code>rentBike(uint256 bikeId)</code>:</p>
        <ul>
            <li>Payable function that allows a user to rent a bike.</li>
            <li>Requires the bike to be available (<code>onlyAvailable</code> modifier) and the payment to be at least the rental price (<code>costs</code> modifier).</li>
            <li>Sets the bike’s status to <code>Rented</code> and updates the <code>rentedUntil</code> timestamp.</li>
            <li>Emits a <code>Rent</code> event.</li>
        </ul>
    </li>
    <li>
        <p><code>returnBike(uint256 bikeId)</code>:</p>
        <ul>
            <li>Allows a user to return a bike.</li>
            <li>Requires the current timestamp to be greater than or equal to the <code>rentedUntil</code> timestamp.</li>
            <li>Sets the bike’s status to <code>Available</code> and resets the <code>rentedUntil</code> timestamp.</li>
            <li>Emits a <code>Return</code> event.</li>
        </ul>
    </li>
    <li>
        <p><code>refund(uint256 bikeId)</code>:</p>
        <ul>
            <li>Allows a user to request a refund for a rented bike.</li>
            <li>Requires the bike to be in the <code>Rented</code> status.</li>
            <li>Sets the bike’s status to <code>Available</code>, resets the <code>rentedUntil</code> timestamp, and transfers the rental price back to the user.</li>
            <li>Emits a <code>Refund</code> event.</li>
        </ul>
    </li>
</ol>

<h3>Query Functions</h3>
<ol>
    <li>
        <p><code>getBikeStatus(uint256 bikeId)</code>:</p>
        <ul>
            <li>Public view function that returns the current status of a bike (either <code>Available</code> or <code>Rented</code>).</li>
        </ul>
    </li>
</ol>

<h2>How it Powers the Dapp's Features</h2>
<ul>
    <li><strong>Bike Rental</strong>: Users can rent a bike by calling the <code>rentBike</code> function and paying the rental fee. This updates the bike’s status and sets a rental period.</li>
    <li><strong>Returning Bikes</strong>: Once the rental period is over, users can return the bike by calling the <code>returnBike</code> function. This makes the bike available for others to rent.</li>
    <li><strong>Refund</strong>: If a bike is rented but needs to be refunded, users can call the <code>refund</code> function to get their rental fee back, and the bike becomes available again.</li>
    <li><strong>Status Inquiry</strong>: Users can check the availability of bikes using the <code>getBikeStatus</code> function.</li>
</ul>

<p>Overall, the contract provides a straightforward interface for renting, returning, and refunding bikes, with each operation being logged through events to ensure transparency and traceability on the blockchain.</p>

</body>
</html>
