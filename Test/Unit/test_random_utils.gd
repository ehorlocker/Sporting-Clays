extends GutTest

## Unit tests for RandomUtils Gaussian distribution functions
## Tests validate statistical properties of random number generation


func test_gaussian_fast_returns_float():
	var result = RandomUtils.gaussian_fast()
	assert_typeof(result, TYPE_FLOAT, "gaussian_fast() should return float")


func test_gaussian_accurate_returns_float():
	var result = RandomUtils.gaussian_accurate()
	assert_typeof(result, TYPE_FLOAT, "gaussian_accurate() should return float")


func test_gaussian_alias_works():
	var result = RandomUtils.gaussian()
	assert_typeof(result, TYPE_FLOAT, "gaussian() alias should return float")


func test_gaussian_range_with_mean():
	var mean = 100.0
	var std_dev = 10.0
	var samples = 1000
	var sum = 0.0

	for i in range(samples):
		sum += RandomUtils.gaussian_range(mean, std_dev)

	var avg = sum / samples
	# Mean should be within 5% of expected (statistical tolerance)
	assert_almost_eq(avg, mean, mean * 0.05, "Mean should be approximately " + str(mean))


func test_gaussian_fast_mean_near_zero():
	var samples = 10000
	var sum = 0.0

	for i in range(samples):
		sum += RandomUtils.gaussian_fast()

	var mean = sum / samples
	# With 10k samples, mean should be very close to 0
	assert_almost_eq(mean, 0.0, 0.05, "Mean should be approximately 0.0")


func test_gaussian_fast_stddev_near_one():
	var samples = 10000
	var sum = 0.0
	var sum_squared = 0.0

	for i in range(samples):
		var val = RandomUtils.gaussian_fast()
		sum += val
		sum_squared += val * val

	var mean = sum / samples
	var variance = (sum_squared / samples) - (mean * mean)
	var std_dev = sqrt(variance)

	# Standard deviation should be close to 1.0
	assert_almost_eq(std_dev, 1.0, 0.1, "Std dev should be approximately 1.0")


func test_gaussian_fast_68_percent_within_one_sigma():
	var samples = 10000
	var within_1_sigma = 0

	for i in range(samples):
		var val = RandomUtils.gaussian_fast()
		if abs(val) <= 1.0:
			within_1_sigma += 1

	var percentage = (within_1_sigma * 100.0) / samples

	# 68.3% ± 5% tolerance
	assert_between(percentage, 63.0, 73.0, "~68% should be within ±1σ")


func test_gaussian_fast_95_percent_within_two_sigma():
	var samples = 10000
	var within_2_sigma = 0

	for i in range(samples):
		var val = RandomUtils.gaussian_fast()
		if abs(val) <= 2.0:
			within_2_sigma += 1

	var percentage = (within_2_sigma * 100.0) / samples

	# 95.4% ± 3% tolerance
	assert_between(percentage, 92.0, 98.0, "~95% should be within ±2σ")


func test_gaussian_fast_997_percent_within_three_sigma():
	var samples = 10000
	var within_3_sigma = 0

	for i in range(samples):
		var val = RandomUtils.gaussian_fast()
		if abs(val) <= 3.0:
			within_3_sigma += 1

	var percentage = (within_3_sigma * 100.0) / samples

	# 99.7% ± 1% tolerance
	assert_between(percentage, 98.5, 100.0, "~99.7% should be within ±3σ")


func test_gaussian_accurate_mean_near_zero():
	var samples = 5000
	var sum = 0.0

	# Reset cached value to ensure clean test
	RandomUtils._has_cached = false

	for i in range(samples):
		sum += RandomUtils.gaussian_accurate()

	var mean = sum / samples
	assert_almost_eq(mean, 0.0, 0.05, "Accurate method mean should be ~0.0")


func test_gaussian_accurate_stddev_near_one():
	var samples = 5000
	var sum = 0.0
	var sum_squared = 0.0

	# Reset cached value
	RandomUtils._has_cached = false

	for i in range(samples):
		var val = RandomUtils.gaussian_accurate()
		sum += val
		sum_squared += val * val

	var mean = sum / samples
	var variance = (sum_squared / samples) - (mean * mean)
	var std_dev = sqrt(variance)

	assert_almost_eq(std_dev, 1.0, 0.1, "Accurate method std dev should be ~1.0")


func test_uniform_unit_vector_has_length_one():
	for i in range(100):
		var vec = RandomUtils.uniform_unit_vector()
		var length = vec.length()
		assert_almost_eq(length, 1.0, 0.001, "Unit vector should have length 1.0")


func test_uniform_unit_vector_is_vector3():
	var vec = RandomUtils.uniform_unit_vector()
	assert_typeof(vec, TYPE_VECTOR3, "Should return Vector3")


func test_gaussian_fast_is_deterministic_with_seed():
	seed(12345)
	var val1 = RandomUtils.gaussian_fast()

	seed(12345)
	var val2 = RandomUtils.gaussian_fast()

	assert_eq(val1, val2, "Same seed should produce same value")
