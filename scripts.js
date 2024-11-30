// Vendor Form Submission
document.getElementById('vendorForm')?.addEventListener('submit', function (e) {
    e.preventDefault(); // Prevent the default form submission

    const vendorData = {
        VendorName: this.VendorName.value,
        ContactInfo: this.ContactInfo.value,
        EmailAddress: this.EmailAddress.value,
        ComplianceCertifications: this.ComplianceCertifications.value,
        PerformanceRating: this.PerformanceRating.value,
    };

    fetch('/api/vendors/register', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(vendorData),
    })
    .then(response => response.json())
    .then(data => {
        alert(data.message); // Display success or error message
        this.reset(); // Reset form fields
    })
    .catch(error => {
        console.error('Error:', error);
        alert('An error occurred while submitting the form. Please try again.');
    });
});
// Contract Form Submission
document.getElementById('contractForm')?.addEventListener('submit', function (e) {
    e.preventDefault();
    const contractData = {
        ContractName: this.ContractName.value,
        StartDate: this.StartDate.value,
        EndDate: this.EndDate.value,
        VendorId: this.VendorId.value,
    };

    fetch('/api/contracts/create', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(contractData),
    })
    .then(response => response.json())
    .then(data => {
        alert(data.message);
        this.reset();
    })
    .catch(error => console.error('Error:', error));
});

// Purchase Order Form Submission
document.getElementById('purchaseOrderForm')?.addEventListener('submit', function (e) {
    e.preventDefault();
    const orderData = {
        OrderNumber: this.OrderNumber.value,
        VendorId: this.VendorId.value,
        OrderDetails: this.OrderDetails.value,
    };

    fetch('/api/purchase-orders/create', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(orderData),
    })
    .then(response => response.json())
    .then(data => {
        alert(data.message);
        this.reset();
    })
    .catch(error => console.error('Error:', error));
});

// Performance Evaluation Form Submission
document.getElementById('performanceForm')?.addEventListener('submit', function (e) {
    e.preventDefault();
    const performanceData = {
        VendorId: this.VendorId.value,
        PerformanceRating: this.PerformanceRating.value,
        Comments: this.Comments.value,
    };

    fetch('/api/performance/evaluate', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(performanceData),
    })
    .then(response => response.json())
    .then(data => {
        alert(data.message);
        this.reset();
    })
    .catch(error => console.error('Error:', error));
});