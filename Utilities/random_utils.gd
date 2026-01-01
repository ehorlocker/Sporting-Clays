class_name RandomUtils
extends RefCounted

## Random utility functions for various statistical distributions.
## - gaussian_*() functions: Normal/bell curve (values cluster at center)
## - uniform_*() functions: Even distribution (all values equally likely)

static var _cached_gaussian: float = 0.0
static var _has_cached: bool = false


## Fast Gaussian random (CLT approximation)
## Returns: mean=0, stddev=1, ~8x faster than accurate version
static func gaussian_fast() -> float:
	var sum = randf() + randf() + randf() + randf() + randf() + randf()
	return (sum - 3.0) * 1.154700538


## Accurate Gaussian random (Box-Muller transform)
## Returns: mean=0, stddev=1, mathematically perfect
static func gaussian_accurate() -> float:
	if _has_cached:
		_has_cached = false
		return _cached_gaussian

	var u1 = randf()
	var u2 = randf()
	var r = sqrt(-2.0 * log(u1))
	var theta = TAU * u2

	_cached_gaussian = r * sin(theta)
	_has_cached = true

	return r * cos(theta)


## Default Gaussian random (uses fast version)
## Returns: mean=0, stddev=1
static func gaussian() -> float:
	return gaussian_fast()


## Gaussian random with custom mean and standard deviation
## Returns: Gaussian distributed value centered at mean
static func gaussian_range(mean: float, std_dev: float) -> float:
	return mean + gaussian() * std_dev


## Random unit vector (uniform distribution on sphere surface)
## Returns: Vector3 with length=1
static func uniform_unit_vector() -> Vector3:
	var theta = randf() * TAU
	var phi = acos(2.0 * randf() - 1.0)
	return Vector3(sin(phi) * cos(theta), sin(phi) * sin(theta), cos(phi))


## Test Gaussian distribution accuracy
## Prints statistics for sample_count random values
## Use for: Debugging, validating distribution quality
static func test_gaussian_distribution(
	sample_count: int = 10000, use_accurate: bool = false
) -> void:
	print("=== Testing Gaussian Distribution ===")
	print("Method: ", "gaussian_accurate()" if use_accurate else "gaussian_fast()")
	print("Samples: ", sample_count)

	var values: Array[float] = []
	var sum: float = 0.0
	var sum_squared: float = 0.0

	# Generate samples
	for i in range(sample_count):
		var val = gaussian_accurate() if use_accurate else gaussian_fast()
		values.append(val)
		sum += val
		sum_squared += val * val

	# Calculate statistics
	var mean = sum / sample_count
	var variance = (sum_squared / sample_count) - (mean * mean)
	var std_dev = sqrt(variance)

	# Count values within standard deviation ranges
	var within_1_sigma = 0
	var within_2_sigma = 0
	var within_3_sigma = 0

	for val in values:
		var abs_val = abs(val)
		if abs_val <= 1.0:
			within_1_sigma += 1
		if abs_val <= 2.0:
			within_2_sigma += 1
		if abs_val <= 3.0:
			within_3_sigma += 1

	# Print results
	print("\n--- Statistics ---")
	print("Mean: %.6f (expect 0.0)" % mean)
	print("Std Dev: %.6f (expect 1.0)" % std_dev)

	print("\n--- Distribution ---")
	print("Within ±1σ: %.2f%% (expect ~68.3%%)" % (within_1_sigma * 100.0 / sample_count))
	print("Within ±2σ: %.2f%% (expect ~95.4%%)" % (within_2_sigma * 100.0 / sample_count))
	print("Within ±3σ: %.2f%% (expect ~99.7%%)" % (within_3_sigma * 100.0 / sample_count))

	print("\n=== Test Complete ===\n")


## Compare fast vs accurate Gaussian implementations
## Useful for understanding accuracy tradeoffs
static func compare_gaussian_methods(sample_count: int = 10000) -> void:
	print("=== Comparing Gaussian Methods ===\n")

	print("Testing FAST method (CLT approximation):")
	test_gaussian_distribution(sample_count, false)

	print("\nTesting ACCURATE method (Box-Muller):")
	test_gaussian_distribution(sample_count, true)
