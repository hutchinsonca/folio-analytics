DROP TABLE IF EXISTS local.po_purchase_orders_acq_unit_ids;

-- These fields in adjustments can be locally defined
CREATE TABLE local.po_purchase_orders_acq_unit_ids AS
WITH po_acq_unit AS (
    SELECT
        id AS po_id,
        po_number AS po_number,
        json_array_elements_text(json_extract_path(data, 'acqUnitIds')) AS po_acq_unit_id
    FROM
        po_purchase_orders
)
SELECT
    po_acq_unit.po_id AS po_id,
    po_acq_unit.po_number,
    po_acq_unit.po_acq_unit_id AS po_acquisition_unit_id,
    json_extract_path_text(acquisitions_units.data, 'name') AS po_acquisition_unit_name
FROM
    po_acq_unit
    LEFT JOIN acquisitions_units ON acquisitions_units.id = po_acq_unit.po_acq_unit_id;

CREATE INDEX ON local.po_purchase_orders_acq_unit_ids (po_id);

CREATE INDEX ON local.po_purchase_orders_acq_unit_ids (po_number);

CREATE INDEX ON local.po_purchase_orders_acq_unit_ids (po_acquisition_unit_id);

CREATE INDEX ON local.po_purchase_orders_acq_unit_ids (po_acquisition_unit_name);
